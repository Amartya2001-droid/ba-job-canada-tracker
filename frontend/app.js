const datasets = {
  "wait-times": {
    label: "Wait times summary",
    url: "../reports/sqlite/wait_times_summary.csv",
    summary: (rows) => {
      const sorted = [...rows].sort(
        (a, b) => Number(b.p95_wait_weeks) - Number(a.p95_wait_weeks),
      );
      const highest = sorted[0];
      return [
        ["Rows", rows.length],
        ["Highest p95", `${highest.p95_wait_weeks} weeks`],
        ["Service", highest.service_type],
      ];
    },
  },
  "facility-coverage": {
    label: "Facility coverage",
    url: "../reports/sqlite/province_facility_coverage.csv",
    summary: (rows) => {
      const sorted = [...rows].sort(
        (a, b) => Number(b.facilities_per_100k) - Number(a.facilities_per_100k),
      );
      const highest = sorted[0];
      const lowest = sorted[sorted.length - 1];
      return [
        ["Rows", rows.length],
        ["Highest", highest.geography],
        ["Lowest", lowest.geography],
      ];
    },
  },
};

const finishGateItems = [
  {
    id: "wait-times-png",
    label: "Wait Times PNG",
    url: "../assets/screenshots/wait-times-dashboard.png",
    pendingText: "Missing final exported dashboard image.",
    readyText: "Final exported dashboard image is present.",
  },
  {
    id: "access-coverage-png",
    label: "Access Coverage PNG",
    url: "../assets/screenshots/access-coverage-dashboard.png",
    pendingText: "Missing final exported dashboard image.",
    readyText: "Final exported dashboard image is present.",
  },
  {
    id: "portfolio-pdf",
    label: "Portfolio PDF",
    url: "../assets/screenshots/healthcare-ba-portfolio.pdf",
    pendingText: "Missing final send-ready PDF proof pack.",
    readyText: "Final send-ready PDF proof pack is present.",
  },
];

let activeRows = [];
let activeConfig = datasets["wait-times"];
let toastTimeout;

function escapeHtml(value) {
  return String(value)
    .replaceAll("&", "&amp;")
    .replaceAll("<", "&lt;")
    .replaceAll(">", "&gt;")
    .replaceAll('"', "&quot;")
    .replaceAll("'", "&#039;");
}

function parseCsv(text) {
  const rows = [];
  let cell = "";
  let row = [];
  let inQuotes = false;

  for (let i = 0; i < text.length; i += 1) {
    const char = text[i];
    const next = text[i + 1];

    if (char === '"' && next === '"') {
      cell += '"';
      i += 1;
    } else if (char === '"') {
      inQuotes = !inQuotes;
    } else if (char === "," && !inQuotes) {
      row.push(cell);
      cell = "";
    } else if ((char === "\n" || char === "\r") && !inQuotes) {
      if (cell || row.length) {
        row.push(cell);
        rows.push(row);
        row = [];
        cell = "";
      }
      if (char === "\r" && next === "\n") {
        i += 1;
      }
    } else {
      cell += char;
    }
  }

  if (cell || row.length) {
    row.push(cell);
    rows.push(row);
  }

  const [headers, ...values] = rows;
  if (!headers) {
    return [];
  }

  return values
    .filter((valueRow) => valueRow.some(Boolean))
    .map((valueRow) =>
      Object.fromEntries(headers.map((header, index) => [header, valueRow[index] ?? ""])),
    );
}

function renderSummary(rows, config) {
  const summary = document.querySelector("#data-summary");
  if (!rows.length) {
    summary.innerHTML = "";
    return;
  }

  summary.innerHTML = config
    .summary(rows)
    .map(
      ([label, value]) => `
        <div class="summary-pill">
          <span>${escapeHtml(label)}</span>
          <strong>${escapeHtml(value)}</strong>
        </div>
      `,
    )
    .join("");
}

function renderTable(rows) {
  const table = document.querySelector("#data-table");
  const count = document.querySelector("#data-count");
  if (count) {
    count.textContent = `${rows.length} row${rows.length === 1 ? "" : "s"} shown`;
  }

  if (!rows.length) {
    table.innerHTML = "<tbody><tr><td>No rows found.</td></tr></tbody>";
    return;
  }

  const headers = Object.keys(rows[0]);
  table.innerHTML = `
    <thead>
      <tr>${headers.map((header) => `<th>${escapeHtml(header)}</th>`).join("")}</tr>
    </thead>
    <tbody>
      ${rows
        .map(
          (row) => `
            <tr>
              ${headers.map((header) => `<td>${escapeHtml(row[header])}</td>`).join("")}
            </tr>
          `,
        )
        .join("")}
    </tbody>
  `;
}

function filterRows(rows, searchTerm) {
  const query = searchTerm.trim().toLowerCase();
  if (!query) {
    return rows;
  }

  return rows.filter((row) =>
    Object.values(row).some((value) => String(value).toLowerCase().includes(query)),
  );
}

function renderActiveDataset() {
  const search = document.querySelector("#dataset-search");
  renderTable(filterRows(activeRows, search?.value ?? ""));
}

function renderFinishGateCard({ status, label, description, detail }) {
  const statusClass = status === "ready" ? "ready" : "pending";
  const statusLabel = status === "ready" ? "Ready" : "Pending";
  const boardClass = status === "ready" ? "ready" : "next";

  return `
    <article class="finish-gate-card ${statusClass}">
      <span class="board-status ${boardClass}">${escapeHtml(statusLabel)}</span>
      <strong>${escapeHtml(label)}</strong>
      <p>${escapeHtml(description)}</p>
      <p class="metric-note">${escapeHtml(detail)}</p>
    </article>
  `;
}

async function checkAssetStatus(item) {
  try {
    const response = await fetch(item.url, { method: "HEAD" });
    if (!response.ok) {
      return {
        status: "pending",
        label: item.label,
        description: item.pendingText,
        detail: "Add the final export to assets/screenshots/.",
      };
    }

    return {
      status: "ready",
      label: item.label,
      description: item.readyText,
      detail: "Asset found in assets/screenshots/.",
    };
  } catch {
    return {
      status: "pending",
      label: item.label,
      description: item.pendingText,
      detail: "Could not verify the asset from the current page load.",
    };
  }
}

function countRealApplications(rows) {
  return rows.filter((row) =>
    Object.values(row).some((value) => String(value).trim().length > 0),
  ).length;
}

function getRealApplicationRows(rows) {
  return rows.filter((row) =>
    Object.values(row).some((value) => String(value).trim().length > 0),
  );
}

function parseScore(value) {
  const match = String(value).match(/(\d+(?:\.\d+)?)/);
  return match ? Number(match[1]) : Number.NEGATIVE_INFINITY;
}

function parseFollowUpDate(value) {
  const trimmed = String(value).trim();
  if (!trimmed) {
    return null;
  }
  const timestamp = Date.parse(trimmed);
  return Number.isNaN(timestamp) ? null : { raw: trimmed, timestamp };
}

async function checkApplicationStatus() {
  try {
    const response = await fetch("../tracker/applications.csv");
    if (!response.ok) {
      throw new Error("Could not load applications.csv");
    }

    const rows = parseCsv(await response.text());
    const realRows = countRealApplications(rows);
    const done = realRows >= 5;

    return {
      status: done ? "ready" : "pending",
      label: "Application Tracker",
      description: done
        ? "Five or more real application rows are recorded."
        : "Fewer than five real application rows are recorded.",
      detail: `${realRows} / 5 real applications logged.`,
    };
  } catch {
    return {
      status: "pending",
      label: "Application Tracker",
      description: "Could not verify the application tracker yet.",
      detail: "Make sure tracker/applications.csv is available from the site.",
    };
  }
}

function renderApplicationCard(row) {
  const role = row.role || "Role missing";
  const company = row.company || "Company missing";
  const location = row.location || "Location missing";
  const score = row.stack_match_score || "n/a";
  const status = row.status || "pending";
  const proof = row.proof_asset || "proof asset not set";
  const followUp = row.follow_up_date || "follow-up date not set";
  const boardClass =
    status.toLowerCase() === "applied" || status.toLowerCase() === "submitted"
      ? "ready"
      : "next";

  return `
    <article class="application-card">
      <span class="board-status ${boardClass}">${escapeHtml(status)}</span>
      <strong>${escapeHtml(role)}</strong>
      <p>${escapeHtml(company)} · ${escapeHtml(location)}</p>
      <div class="application-meta">
        <span>Stack match: ${escapeHtml(score)}</span>
        <span>Proof asset: ${escapeHtml(proof)}</span>
        <span>Follow-up: ${escapeHtml(followUp)}</span>
      </div>
    </article>
  `;
}

function renderApplicationSummary(rows) {
  const summary = document.querySelector("#application-summary");
  if (!summary) {
    return;
  }

  if (!rows.length) {
    summary.innerHTML = `
      <div class="summary-pill">
        <span>Rows</span>
        <strong>0</strong>
      </div>
      <div class="summary-pill">
        <span>Submitted</span>
        <strong>0</strong>
      </div>
      <div class="summary-pill">
        <span>Best Match</span>
        <strong>n/a</strong>
      </div>
      <div class="summary-pill">
        <span>Next Follow-up</span>
        <strong>n/a</strong>
      </div>
    `;
    return;
  }

  const submittedCount = rows.filter((row) =>
    ["applied", "submitted", "interview", "follow-up"].includes(
      String(row.status).trim().toLowerCase(),
    ),
  ).length;

  const bestMatch = [...rows].sort(
    (a, b) => parseScore(b.stack_match_score) - parseScore(a.stack_match_score),
  )[0];

  const nextFollowUp = rows
    .map((row) => parseFollowUpDate(row.follow_up_date))
    .filter(Boolean)
    .sort((a, b) => a.timestamp - b.timestamp)[0];

  summary.innerHTML = `
    <div class="summary-pill">
      <span>Rows</span>
      <strong>${escapeHtml(rows.length)}</strong>
    </div>
    <div class="summary-pill">
      <span>Submitted</span>
      <strong>${escapeHtml(submittedCount)}</strong>
    </div>
    <div class="summary-pill">
      <span>Best Match</span>
      <strong>${escapeHtml(bestMatch?.stack_match_score || "n/a")}</strong>
    </div>
    <div class="summary-pill">
      <span>Next Follow-up</span>
      <strong>${escapeHtml(nextFollowUp?.raw || "n/a")}</strong>
    </div>
  `;
}

async function renderApplicationBoard() {
  const container = document.querySelector("#application-board");
  if (!container) {
    return;
  }

  try {
    const response = await fetch("../tracker/applications.csv");
    if (!response.ok) {
      throw new Error("Could not load applications.csv");
    }

    const rows = getRealApplicationRows(parseCsv(await response.text()));
    renderApplicationSummary(rows);
    if (!rows.length) {
      container.innerHTML = `
        <article class="application-card empty">
          <span class="board-status next">Waiting</span>
          <strong>No real application rows yet</strong>
          <p>Fill <code>tracker/applications.csv</code> to turn this into a live application pipeline.</p>
        </article>
      `;
      return;
    }

    container.innerHTML = rows.slice(0, 5).map(renderApplicationCard).join("");
  } catch (error) {
    renderApplicationSummary([]);
    container.innerHTML = `
      <article class="application-card empty">
        <span class="board-status next">Pending</span>
        <strong>Application board unavailable</strong>
        <p>${escapeHtml(error.message)}</p>
      </article>
    `;
  }
}

async function renderFinishGate() {
  const container = document.querySelector("#finish-gate-grid");
  if (!container) {
    return;
  }

  const assetStatuses = await Promise.all(finishGateItems.map(checkAssetStatus));
  const applicationStatus = await checkApplicationStatus();
  container.innerHTML = [...assetStatuses, applicationStatus]
    .map(renderFinishGateCard)
    .join("");
}

function showToast(message) {
  const toast = document.querySelector("#toast");
  if (!toast) {
    return;
  }

  toast.textContent = message;
  toast.classList.add("visible");
  clearTimeout(toastTimeout);
  toastTimeout = setTimeout(() => toast.classList.remove("visible"), 2200);
}

async function copyText(value) {
  try {
    await navigator.clipboard.writeText(value);
    showToast("Pitch copied to clipboard.");
  } catch {
    showToast("Copy failed. Select the text manually from the project card.");
  }
}

async function loadDataset(key) {
  const config = datasets[key];
  const table = document.querySelector("#data-table");
  const summary = document.querySelector("#data-summary");
  const count = document.querySelector("#data-count");
  const download = document.querySelector("#dataset-download");
  const search = document.querySelector("#dataset-search");

  table.innerHTML = "<tbody><tr><td>Loading...</td></tr></tbody>";
  summary.innerHTML = "";
  if (search) {
    search.value = "";
  }
  if (count) {
    count.textContent = "";
  }
  if (download) {
    download.href = config.url;
  }
  activeConfig = config;

  try {
    const response = await fetch(config.url);
    if (!response.ok) {
      throw new Error(`Could not load ${config.url}`);
    }
    const rows = parseCsv(await response.text());
    activeRows = rows;
    renderSummary(activeRows, activeConfig);
    renderActiveDataset();
  } catch (error) {
    table.innerHTML = `<tbody><tr><td>${escapeHtml(error.message)}</td></tr></tbody>`;
  }
}

const select = document.querySelector("#dataset-select");
const search = document.querySelector("#dataset-search");
const copyButtons = document.querySelectorAll("[data-copy]");

if (select) {
  select.addEventListener("change", (event) => loadDataset(event.target.value));
  loadDataset(select.value);
}

if (search) {
  search.addEventListener("input", renderActiveDataset);
}

copyButtons.forEach((button) => {
  button.addEventListener("click", () => copyText(button.dataset.copy ?? ""));
});

renderFinishGate();
renderApplicationBoard();
