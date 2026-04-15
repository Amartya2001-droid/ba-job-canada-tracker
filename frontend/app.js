const datasets = {
  "wait-times": {
    label: "Wait times summary",
    url: "/reports/sqlite/wait_times_summary.csv",
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
    url: "/reports/sqlite/province_facility_coverage.csv",
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
