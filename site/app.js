const PORTAL_CONFIG = {
  // Replace with SHA-256 of your portal passphrase.
  // Example generator:
  // powershell -NoProfile -Command "$s='your-pass'; $sha=[Security.Cryptography.SHA256]::Create(); ([BitConverter]::ToString($sha.ComputeHash([Text.Encoding]::UTF8.GetBytes($s)))).Replace('-','').ToLower()"
  passphraseSha256: "01492d0a83facb9e8a0d4864a7b3f8f9de004edac9e5075846164da5777d0805",
};

const gate = document.querySelector("#gate");
const portal = document.querySelector("#portal");
const form = document.querySelector("#login-form");
const passInput = document.querySelector("#portal-pass");
const status = document.querySelector("#login-status");
const lockAgain = document.querySelector("#lock-again");

async function sha256Hex(text) {
  const data = new TextEncoder().encode(text);
  const digest = await crypto.subtle.digest("SHA-256", data);
  return Array.from(new Uint8Array(digest), byte => byte.toString(16).padStart(2, "0")).join("");
}

function setUnlocked(unlocked) {
  gate.classList.toggle("hidden", unlocked);
  portal.classList.toggle("hidden", !unlocked);
  if (unlocked) {
    sessionStorage.setItem("julia_portal_unlocked", "1");
  } else {
    sessionStorage.removeItem("julia_portal_unlocked");
  }
}

form.addEventListener("submit", async event => {
  event.preventDefault();
  status.textContent = "";

  if (!PORTAL_CONFIG.passphraseSha256 || PORTAL_CONFIG.passphraseSha256 === "replace-with-sha256") {
    status.textContent = "Portal passphrase hash is not configured yet.";
    return;
  }

  const hash = await sha256Hex(passInput.value);
  if (hash === PORTAL_CONFIG.passphraseSha256.toLowerCase()) {
    passInput.value = "";
    setUnlocked(true);
  } else {
    status.textContent = "Incorrect passphrase.";
  }
});

lockAgain.addEventListener("click", () => setUnlocked(false));

if (sessionStorage.getItem("julia_portal_unlocked") === "1") {
  setUnlocked(true);
}
