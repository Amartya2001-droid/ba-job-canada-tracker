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
    assetType: "image",
    previewUrl: "../assets/screenshots/wait-times-dashboard-preview.svg",
    pendingText: "Missing final exported dashboard image.",
    readyText: "Final exported dashboard image is present.",
  },
  {
    id: "access-coverage-png",
    label: "Access Coverage PNG",
    url: "../assets/screenshots/access-coverage-dashboard.png",
    assetType: "image",
    previewUrl: "../assets/screenshots/access-coverage-dashboard-preview.svg",
    pendingText: "Missing final exported dashboard image.",
    readyText: "Final exported dashboard image is present.",
  },
  {
    id: "portfolio-pdf",
    label: "Portfolio PDF",
    url: "../assets/screenshots/healthcare-ba-portfolio.pdf",
    assetType: "pdf",
    guideUrl: "../docs/powerbi-export-pack.md",
    pendingText: "Missing final send-ready PDF proof pack.",
    readyText: "Final send-ready PDF proof pack is present.",
  },
];

let activeRows = [];
let activeConfig = datasets["wait-times"];
let toastTimeout;
let latestApplicationRows = [];
let latestFinishStatuses = [];

const entryFieldSelectors = [
  "#entry-company",
  "#entry-role",
  "#entry-location",
  "#entry-job-link",
  "#entry-required-tools",
  "#entry-matching-tools",
  "#entry-stack-match",
  "#entry-domain-fit",
  "#entry-proof-asset",
  "#entry-status",
  "#entry-follow-up",
  "#entry-notes",
];

const entryStorageKey = "healthcare-ba-entry-helper";
const sampleEntryValues = {
  "#entry-company": "Nova Scotia Health",
  "#entry-role": "Business Analyst",
  "#entry-location": "Halifax, NS",
  "#entry-job-link": "https://example.com/healthcare-ba-role",
  "#entry-required-tools": "SQL, Power BI, Excel, stakeholder reporting",
  "#entry-matching-tools": "SQL, Power BI, Excel",
  "#entry-stack-match": "4/5",
  "#entry-domain-fit": "Healthcare operations analytics and KPI reporting",
  "#entry-proof-asset": "wait-times-dashboard-preview.svg",
  "#entry-status": "shortlist",
  "#entry-follow-up": "2026-07-31",
  "#entry-notes": "Lead with the wait-times p95 delay insight and dashboard story.",
};

function escapeHtml(value) {
  return String(value)
    .replaceAll("&", "&amp;")
    .replaceAll("<", "&lt;")
    .replaceAll(">", "&gt;")
    .replaceAll('"', "&quot;")
    .replaceAll("'", "&#039;");
}

function toCsvCell(value) {
  const stringValue = String(value ?? "");
  if (/[",\n]/.test(stringValue)) {
    return `"${stringValue.replaceAll('"', '""')}"`;
  }
  return stringValue;
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
        id: item.id,
        label: item.label,
        url: item.url,
        assetType: item.assetType,
        previewUrl: item.previewUrl,
        guideUrl: item.guideUrl,
        description: item.pendingText,
        detail: "Add the final export to assets/screenshots/.",
      };
    }

    return {
      status: "ready",
      id: item.id,
      label: item.label,
      url: item.url,
      assetType: item.assetType,
      previewUrl: item.previewUrl,
      guideUrl: item.guideUrl,
      description: item.readyText,
      detail: "Asset found in assets/screenshots/.",
    };
  } catch {
    return {
      status: "pending",
      id: item.id,
      label: item.label,
      url: item.url,
      assetType: item.assetType,
      previewUrl: item.previewUrl,
      guideUrl: item.guideUrl,
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
    latestApplicationRows = rows;
    renderApplicationSummary(rows);
    renderFinishCoach();
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
    latestApplicationRows = [];
    renderApplicationSummary([]);
    renderFinishCoach();
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
  latestFinishStatuses = [...assetStatuses, applicationStatus];
  container.innerHTML = latestFinishStatuses.map(renderFinishGateCard).join("");
  renderAssetLocker(latestFinishStatuses);
  renderFinishCoach();
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

async function copyText(value, successMessage = "Copied to clipboard.") {
  try {
    await navigator.clipboard.writeText(value);
    showToast(successMessage);
  } catch {
    showToast("Copy failed. Select the text manually from the dashboard.");
  }
}

function getEntryValue(id) {
  return document.querySelector(id)?.value?.trim() ?? "";
}

function setEntryValue(id, value) {
  const input = document.querySelector(id);
  if (input) {
    input.value = value;
  }
}

function saveEntryDraft() {
  const payload = Object.fromEntries(
    entryFieldSelectors.map((selector) => [selector, getEntryValue(selector)]),
  );

  try {
    localStorage.setItem(entryStorageKey, JSON.stringify(payload));
  } catch {
    // Ignore storage issues and keep the helper usable.
  }
}

function restoreEntryDraft() {
  try {
    const saved = localStorage.getItem(entryStorageKey);
    if (!saved) {
      return;
    }

    const payload = JSON.parse(saved);
    entryFieldSelectors.forEach((selector) => {
      if (typeof payload?.[selector] === "string") {
        setEntryValue(selector, payload[selector]);
      }
    });
  } catch {
    // Ignore malformed drafts and allow a fresh start.
  }
}

function clearEntryDraft() {
  entryFieldSelectors.forEach((selector) => setEntryValue(selector, ""));
  try {
    localStorage.removeItem(entryStorageKey);
  } catch {
    // Ignore storage cleanup issues.
  }
  renderEntryHelperOutputs();
  showToast("Entry helper draft cleared.");
}

function fillEntrySample() {
  Object.entries(sampleEntryValues).forEach(([selector, value]) =>
    setEntryValue(selector, value),
  );
  saveEntryDraft();
  renderEntryHelperOutputs();
  showToast("Healthcare sample loaded into the entry helper.");
}

function buildEntryCsvRow() {
  const today = new Date().toISOString().slice(0, 10);
  const fields = [
    today,
    getEntryValue("#entry-company"),
    getEntryValue("#entry-role"),
    getEntryValue("#entry-location"),
    getEntryValue("#entry-job-link"),
    getEntryValue("#entry-required-tools"),
    getEntryValue("#entry-matching-tools"),
    getEntryValue("#entry-stack-match"),
    getEntryValue("#entry-domain-fit"),
    getEntryValue("#entry-proof-asset"),
    getEntryValue("#entry-status"),
    getEntryValue("#entry-follow-up"),
    getEntryValue("#entry-notes"),
  ];

  return fields.map(toCsvCell).join(",");
}

function buildEntryMarkdownBlock() {
  return `- company: ${getEntryValue("#entry-company") || "[Company]"}
- role: ${getEntryValue("#entry-role") || "[Role]"}
- location: ${getEntryValue("#entry-location") || "[Location]"}
- job link: ${getEntryValue("#entry-job-link") || "[Job Link]"}
- why it fits: ${getEntryValue("#entry-domain-fit") || "[Why it fits]"}
- matching tools: ${getEntryValue("#entry-matching-tools") || "[Matching tools]"}
- stack match score: ${getEntryValue("#entry-stack-match") || "[Stack match score]"}
- project bullet to emphasize: ${getEntryValue("#entry-notes") || "[Project bullet]"}
- proof asset to link: ${getEntryValue("#entry-proof-asset") || "[Proof asset]"}
- status: ${getEntryValue("#entry-status") || "[Status]"}`;
}

function renderEntryHelperOutputs() {
  const csvOutput = document.querySelector("#entry-csv-output");
  const mdOutput = document.querySelector("#entry-md-output");
  if (!csvOutput || !mdOutput) {
    return;
  }

  const hasAnyValue = [
    "#entry-company",
    "#entry-role",
    "#entry-location",
    "#entry-job-link",
    "#entry-required-tools",
    "#entry-matching-tools",
    "#entry-stack-match",
    "#entry-domain-fit",
    "#entry-proof-asset",
    "#entry-status",
    "#entry-follow-up",
    "#entry-notes",
  ].some((selector) => getEntryValue(selector));

  if (!hasAnyValue) {
    csvOutput.textContent = "Fill the helper to generate a CSV row.";
    mdOutput.textContent = "Fill the helper to generate a markdown block.";
    return;
  }

  csvOutput.textContent = buildEntryCsvRow();
  mdOutput.textContent = buildEntryMarkdownBlock();
}

function renderFinishCoach() {
  const container = document.querySelector("#finish-coach");
  if (!container) {
    return;
  }

  if (!latestFinishStatuses.length) {
    container.innerHTML = `
      <article class="coach-card">
        <span class="board-status next">Checking</span>
        <strong>Loading finish guidance</strong>
        <p>Reviewing export assets and application tracker progress.</p>
      </article>
    `;
    return;
  }

  const missingAssets = latestFinishStatuses.filter(
    (item) => item.label !== "Application Tracker" && item.status !== "ready",
  );
  const applicationStatus = latestFinishStatuses.find((item) => item.label === "Application Tracker");
  const realApplicationCount = latestApplicationRows.length;
  const statusClass = missingAssets.length === 0 && realApplicationCount >= 5 ? "ready" : "next";
  const statusLabel = statusClass === "ready" ? "Ready" : "Focus";

  let headline = "Export the final Power BI proof assets";
  let message =
    "The repo build is strong. The main blocker is still the final PNG and PDF export pack.";

  if (!missingAssets.length && realApplicationCount < 5) {
    headline = "Fill the first five healthcare applications";
    message =
      "The visual proof is ready, so the next move is replacing tracker placeholders with real healthcare roles.";
  } else if (!missingAssets.length && realApplicationCount >= 5) {
    headline = "Run the final rehearsal and send-ready pass";
    message =
      "The export pack and first five roles are in place. Finish with a final walkthrough and selective applications.";
  }

  const missingAssetLabels = missingAssets.length
    ? missingAssets.map((item) => item.label).join(", ")
    : "No export blockers";

  container.innerHTML = `
    <article class="coach-card">
      <span class="board-status ${statusClass}">${escapeHtml(statusLabel)}</span>
      <strong>${escapeHtml(headline)}</strong>
      <p>${escapeHtml(message)}</p>
      <div class="coach-metrics">
        <div class="summary-pill">
          <span>Missing exports</span>
          <strong>${escapeHtml(String(missingAssets.length))}</strong>
        </div>
        <div class="summary-pill">
          <span>Application rows</span>
          <strong>${escapeHtml(`${realApplicationCount} / 5`)}</strong>
        </div>
        <div class="summary-pill">
          <span>Tracker status</span>
          <strong>${escapeHtml(applicationStatus?.status === "ready" ? "Ready" : "Pending")}</strong>
        </div>
      </div>
      <p class="metric-note">Current blockers: ${escapeHtml(missingAssetLabels)}</p>
      <div class="resource-links">
        <a href="../docs/powerbi-export-pack.md">Open Export Pack</a>
        <a href="../tracker/applications.csv">Open applications.csv</a>
        <a href="../docs/final-submission-runbook.md">Open Submission Runbook</a>
      </div>
    </article>
  `;
}

function renderAssetLocker(statuses) {
  const container = document.querySelector("#asset-locker");
  if (!container) {
    return;
  }

  container.innerHTML = statuses
    .filter((item) => item.label !== "Application Tracker")
    .map((item) => {
      const statusClass = item.status === "ready" ? "ready" : "pending";
      const statusLabel = item.status === "ready" ? "Ready" : "Pending";
      const preview =
        item.assetType === "image"
          ? `
            <div class="asset-preview">
              <img
                src="${escapeHtml(item.status === "ready" ? item.url : item.previewUrl)}"
                alt="${escapeHtml(item.label)}"
              />
            </div>
          `
          : `
            <div class="asset-preview asset-preview-pdf">
              <span>PDF</span>
            </div>
          `;

      const actionUrl =
        item.status === "ready" ? item.url : item.guideUrl || "../docs/powerbi-export-pack.md";
      const actionLabel = item.status === "ready" ? "Open Asset" : "Open Export Guide";
      const detail =
        item.status === "ready"
          ? "Final asset committed in the repo."
          : item.url.replace("../assets/screenshots/", "Expected file: ");

      return `
        <article class="asset-card ${statusClass}">
          <span class="board-status ${item.status === "ready" ? "ready" : "next"}">${escapeHtml(statusLabel)}</span>
          <strong>${escapeHtml(item.label)}</strong>
          ${preview}
          <p>${escapeHtml(item.description)}</p>
          <p class="metric-note">${escapeHtml(detail)}</p>
          <div class="resource-links">
            <a href="${escapeHtml(actionUrl)}">${escapeHtml(actionLabel)}</a>
          </div>
        </article>
      `;
    })
    .join("");
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
  button.addEventListener("click", () =>
    copyText(button.dataset.copy ?? "", "Pitch copied to clipboard."),
  );
});

entryFieldSelectors.forEach((selector) => {
  const input = document.querySelector(selector);
  input?.addEventListener("input", () => {
    saveEntryDraft();
    renderEntryHelperOutputs();
  });
});

document
  .querySelector("#copy-csv-entry")
  ?.addEventListener("click", () =>
    copyText(buildEntryCsvRow(), "CSV application row copied to clipboard."),
  );

document
  .querySelector("#copy-md-entry")
  ?.addEventListener("click", () =>
    copyText(buildEntryMarkdownBlock(), "Worksheet markdown block copied to clipboard."),
  );

document.querySelector("#clear-entry-helper")?.addEventListener("click", clearEntryDraft);
document.querySelector("#fill-entry-sample")?.addEventListener("click", fillEntrySample);

restoreEntryDraft();
renderFinishGate();
renderApplicationBoard();
renderEntryHelperOutputs();
