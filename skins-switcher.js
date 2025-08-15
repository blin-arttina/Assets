/* assets-alert skins switcher */
(function () {
  const MANIFEST_URL = 'assets-alert-skins.manifest.json';
  const STORAGE_KEY = 'assets_alert_skin';

  function ensureLink() {
    let link = document.getElementById('skinStylesheet');
    if (!link) {
      link = document.createElement('link');
      link.rel = 'stylesheet';
      link.id = 'skinStylesheet';
      document.head.appendChild(link);
    }
    return link;
  }

  function applySkin(slug, cssFile) {
    document.documentElement.setAttribute('data-skin', slug);
    const link = ensureLink();
    link.href = cssFile;
    try { localStorage.setItem(STORAGE_KEY, JSON.stringify({ slug, cssFile })); } catch(e){}
  }

  async function loadManifest() {
    const res = await fetch(MANIFEST_URL);
    if (!res.ok) throw new Error('Failed to load skins manifest');
    return await res.json();
  }

  function openModal(items) {
    const existing = document.getElementById('skinModal');
    if (existing) existing.remove();

    const modal = document.createElement('div');
    modal.id = 'skinModal';
    modal.setAttribute('role', 'dialog');
    modal.setAttribute('aria-modal', 'true');
    modal.style.position = 'fixed';
    modal.style.inset = '0';
    modal.style.background = 'rgba(0,0,0,.6)';
    modal.style.display = 'flex';
    modal.style.alignItems = 'center';
    modal.style.justifyContent = 'center';
    modal.style.zIndex = '9999';

    const panel = document.createElement('div');
    panel.style.background = '#141419';
    panel.style.color = '#fff';
    panel.style.border = '2px solid #3a3a44';
    panel.style.borderRadius = '16px';
    panel.style.width = 'min(520px, 92vw)';
    panel.style.maxHeight = '80vh';
    panel.style.overflow = 'auto';
    panel.style.padding = '16px 16px 8px 16px';
    panel.style.boxShadow = '0 12px 40px rgba(0,0,0,.5)';

    const title = document.createElement('h2');
    title.textContent = 'Choose Skin';
    title.style.margin = '0 0 8px 0';
    panel.appendChild(title);

    const list = document.createElement('div');
    for (const it of items) {
      const row = document.createElement('div');
      row.style.display = 'grid';
      row.style.gridTemplateColumns = '96px 1fr auto';
      row.style.gap = '12px';
      row.style.alignItems = 'center';
      row.style.padding = '10px 0';
      row.style.borderTop = '1px solid #3a3a44';

      const img = document.createElement('img');
      img.src = it.preview;
      img.alt = it.skin + ' preview';
      img.width = 96; img.height = 64;
      img.style.objectFit = 'cover';
      img.style.border = '1px solid #3a3a44';
      img.style.borderRadius = '8px';

      const name = document.createElement('div');
      name.innerHTML = '<strong>' + it.skin + '</strong><br><code>' + it.slug + '</code>';

      const btn = document.createElement('button');
      btn.textContent = 'Use Skin';
      btn.style.fontSize = '18px';
      btn.style.padding = '10px 14px';
      btn.style.background = '#e11900';
      btn.style.color = '#fff';
      btn.style.border = '2px solid #3a3a44';
      btn.style.borderRadius = '12px';
      btn.style.cursor = 'pointer';
      btn.addEventListener('click', () => {
        applySkin(it.slug, it.css);
        modal.remove();
      });

      row.appendChild(img);
      row.appendChild(name);
      row.appendChild(btn);
      list.appendChild(row);
    }
    panel.appendChild(list);

    const close = document.createElement('button');
    close.textContent = 'Close';
    close.style.marginTop = '12px';
    close.style.fontSize = '18px';
    close.style.padding = '10px 16px';
    close.style.background = '#2a2a2a';
    close.style.color = '#fff';
    close.style.border = '2px solid #3a3a44';
    close.style.borderRadius = '12px';
    close.addEventListener('click', () => modal.remove());
    panel.appendChild(close);

    modal.appendChild(panel);
    document.body.appendChild(modal);

    // focus trapping basic
    close.focus();
  }

  async function initGear() {
    // Restore last skin
    try {
      const saved = JSON.parse(localStorage.getItem(STORAGE_KEY) || 'null');
      if (saved && saved.slug && saved.cssFile) {
        applySkin(saved.slug, saved.cssFile);
      }
    } catch(e){}

    // Build button if missing
    let gear = document.getElementById('skinGearButton');
    if (!gear) {
      gear = document.createElement('button');
      gear.id = 'skinGearButton';
      gear.title = 'Skins / Settings';
      gear.setAttribute('aria-label', 'Skins and Settings');
      gear.style.position = 'fixed';
      gear.style.top = '10px';
      gear.style.right = '10px';
      gear.style.width = '56px';
      gear.style.height = '56px';
      gear.style.borderRadius = '50%';
      gear.style.border = '2px solid #3a3a44';
      gear.style.background = '#b00020';
      gear.style.cursor = 'pointer';
      gear.style.display = 'grid';
      gear.style.placeItems = 'center';
      gear.style.zIndex = '10000';
      gear.innerHTML = '<svg xmlns="http://www.w3.org/2000/svg" width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="#fff" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="3"></circle><path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 1 1-2.83 2.83l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 1 1-4 0v-.09a1.65 1.65 0 0 0-1-1.51 1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 1 1-2.83-2.83l.06-.06a1.65 1.65 0 0 0 .33-1.82 1.65 1.65 0 0 0-1.51-1H3a2 2 0 1 1 0-4h.09a1.65 1.65 0 0 0 1.51-1 1.65 1.65 0 0 0-.33-1.82l-.06-.06A2 2 0 1 1 7.04 3.3l.06.06c.48.48 1.18.62 1.82.33A1.65 1.65 0 0 0 10 2.18V2a2 2 0 1 1 4 0v.18c0 .66.39 1.25 1 1.51.64.29 1.34.15 1.82-.33l.06-.06a2 2 0 1 1 2.83 2.83l-.06.06c-.48.48-.62 1.18-.33 1.82.26.61.85 1 1.51 1H22a2 2 0 1 1 0 4h-.18c-.66 0-1.25.39-1.51 1z"/></svg>';
      document.body.appendChild(gear);
    }

    // Wire modal
    gear.addEventListener('click', async () => {
      try {
        const items = await loadManifest();
        openModal(items);
      } catch (e) {
        alert('Could not load skins manifest. Make sure assets-alert-skins.manifest.json is in the same directory.');
      }
    });
  }

  // Initialize on DOM ready
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initGear);
  } else {
    initGear();
  }
})();