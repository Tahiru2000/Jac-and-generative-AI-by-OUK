(async () => {
  const chatDiv = document.getElementById("chat");
  const inp = document.getElementById("inp");
  const send = document.getElementById("send");
  let session = Math.random().toString(36).substring(2, 15);

  function appendMsg(who, text) {
    const d = document.createElement("div");
    d.className = who === "user" ? "userMsg" : "botMsg";
    d.innerText = text;
    chatDiv.appendChild(d);
    chatDiv.scrollTop = chatDiv.scrollHeight;
  }

  send.onclick = async () => {
    const q = inp.value;
    if (!q) return;
    appendMsg("user", q);
    inp.value = "";
    try {
      const resp = await fetch("/agent/query", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ session: session, query: q })
      });
      const j = await resp.json();
      appendMsg("bot", j.answer);
    } catch (e) {
      appendMsg("bot", "Error contacting agent: " + e.message);
    }
  };
})();
