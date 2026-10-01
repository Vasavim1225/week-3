<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
  String user = (String) session.getAttribute("username");
  if (user == null) { response.sendRedirect("login.jsp"); return; }
  String safe = user.replace("&","&amp;").replace("<","&lt;").replace(">","&gt;").replace("\"","&quot;");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Chat</title>

<style>
  * {
    box-sizing: border-box;
  }

  :root {
    --bg: #f5f7fb;
    --panel: #ffffff;
    --sidebar: #111827;
    --sidebar-hover: #1f2937;
    --primary: #6366f1;
    --primary-dark: #4f46e5;
    --text: #111827;
    --muted: #6b7280;
    --border: #e5e7eb;
    --incoming: #f1f3f7;
    --outgoing: #6366f1;
  }

  body {
    margin: 0;
    min-height: 100vh;
    font-family: "Segoe UI", Arial, sans-serif;
    background:
      radial-gradient(circle at 10% 10%, rgba(99,102,241,.12), transparent 30%),
      radial-gradient(circle at 90% 90%, rgba(14,165,233,.10), transparent 30%),
      var(--bg);
    color: var(--text);
    display: flex;
    align-items: center;
    justify-content: center;
  }

  .app {
    width: min(1250px, 95vw);
    height: min(760px, 92vh);
    display: flex;
    overflow: hidden;
    background: var(--panel);
    border: 1px solid rgba(0,0,0,.06);
    border-radius: 24px;
    box-shadow: 0 25px 70px rgba(15,23,42,.15);
  }

  /* LEFT NAVIGATION */

  .nav {
    width: 210px;
    background: var(--sidebar);
    color: white;
    padding: 22px 14px;
    display: flex;
    flex-direction: column;
  }

  .brand {
    display: flex;
    align-items: center;
    gap: 10px;
    padding: 8px 12px 30px;
    font-size: 20px;
    font-weight: 700;
  }

  .brand-icon {
    width: 38px;
    height: 38px;
    border-radius: 12px;
    display: flex;
    align-items: center;
    justify-content: center;
    background: linear-gradient(135deg, #818cf8, #4f46e5);
    box-shadow: 0 8px 20px rgba(79,70,229,.35);
  }

  .who {
    display: flex;
    align-items: center;
    gap: 10px;
    padding: 10px;
    margin-bottom: 22px;
    border-radius: 14px;
    background: rgba(255,255,255,.06);
  }

  .who-info {
    min-width: 0;
  }

  .who-name {
    font-size: 14px;
    font-weight: 600;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
  }

  .online {
    display: flex;
    align-items: center;
    gap: 5px;
    margin-top: 3px;
    color: #a7f3d0;
    font-size: 11px;
  }

  .online-dot {
    width: 7px;
    height: 7px;
    border-radius: 50%;
    background: #34d399;
  }

  .nav-links {
    display: flex;
    flex-direction: column;
    gap: 6px;
  }

  .navitem {
    display: flex;
    align-items: center;
    gap: 12px;
    padding: 12px 14px;
    border-radius: 12px;
    color: #cbd5e1;
    text-decoration: none;
    font-size: 14px;
    transition: .2s;
  }

  .navitem:hover {
    background: var(--sidebar-hover);
    color: white;
  }

  .navitem.active {
    background: linear-gradient(90deg, #4f46e5, #6366f1);
    color: white;
    box-shadow: 0 8px 20px rgba(79,70,229,.25);
  }

  .nav-bottom {
    margin-top: auto;
  }

  /* USER LIST */

  .list {
    width: 330px;
    border-right: 1px solid var(--border);
    background: #fafbfc;
    display: flex;
    flex-direction: column;
    min-width: 0;
  }

  .list-header {
    padding: 26px 22px 18px;
  }

  .list-title {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 18px;
  }

  .list h2 {
    margin: 0;
    font-size: 23px;
    font-weight: 700;
  }

  .chat-count {
    font-size: 11px;
    padding: 5px 9px;
    border-radius: 20px;
    background: #eef2ff;
    color: #4f46e5;
    font-weight: 600;
  }

  .search-wrap {
    position: relative;
  }

  .search-icon {
    position: absolute;
    left: 14px;
    top: 50%;
    transform: translateY(-50%);
    color: #9ca3af;
    font-size: 15px;
  }

  #search {
    width: 100%;
    height: 42px;
    padding: 0 15px 0 39px;
    border: 1px solid var(--border);
    border-radius: 12px;
    outline: none;
    background: white;
    color: var(--text);
    font-size: 13px;
    transition: .2s;
  }

  #search:focus {
    border-color: #818cf8;
    box-shadow: 0 0 0 3px rgba(99,102,241,.10);
  }

  #search::placeholder {
    color: #9ca3af;
  }

  #users {
    flex: 1;
    overflow-y: auto;
    padding: 0 10px 12px;
  }

  #users::-webkit-scrollbar,
  #box::-webkit-scrollbar {
    width: 5px;
  }

  #users::-webkit-scrollbar-thumb,
  #box::-webkit-scrollbar-thumb {
    background: #d1d5db;
    border-radius: 20px;
  }

  .u {
    display: flex;
    align-items: center;
    gap: 12px;
    padding: 12px;
    margin-bottom: 3px;
    border-radius: 14px;
    cursor: pointer;
    transition: .18s;
  }

  .u:hover {
    background: #f0f2f7;
  }

  .u.sel {
    background: #eef2ff;
  }

  .ut {
    flex: 1;
    min-width: 0;
  }

  .un {
    font-weight: 600;
    font-size: 14px;
    color: #1f2937;
  }

  .ul {
    font-size: 12px;
    color: #8b95a5;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
    margin-top: 3px;
  }

  .ud {
    font-size: 10px;
    color: #9ca3af;
    align-self: flex-start;
    margin-top: 2px;
  }

  /* AVATARS */

  .av {
    width: 43px;
    height: 43px;
    border-radius: 50%;
    flex: none;
    display: flex;
    align-items: center;
    justify-content: center;
    font-weight: 700;
    color: white;
    font-size: 15px;
    box-shadow: inset 0 0 0 2px rgba(255,255,255,.25);
  }

  /* CHAT */

  .chat {
    flex: 1;
    display: flex;
    flex-direction: column;
    min-width: 0;
    background: white;
  }

  .head {
    min-height: 76px;
    display: flex;
    align-items: center;
    gap: 13px;
    padding: 15px 22px;
    border-bottom: 1px solid var(--border);
  }

  .head .av {
    width: 43px;
    height: 43px;
  }

  .hn {
    font-weight: 700;
    font-size: 15px;
    color: #111827;
  }

  .hs {
    font-size: 12px;
    color: #8b95a5;
    margin-top: 3px;
  }

  #box {
    flex: 1;
    overflow-y: auto;
    padding: 25px 30px;
    background:
      radial-gradient(circle at 20% 10%, rgba(99,102,241,.025), transparent 30%),
      #ffffff;
  }

  .empty {
    text-align: center;
    color: #9ca3af;
    font-size: 13px;
    margin-top: 100px;
  }

  .m {
    max-width: 70%;
    margin-bottom: 18px;
  }

  .m.me {
    margin-left: auto;
    text-align: right;
  }

  .bub {
    display: inline-block;
    padding: 11px 15px;
    border-radius: 18px 18px 18px 5px;
    font-size: 14px;
    line-height: 1.45;
    text-align: left;
    word-break: break-word;
    color: #374151;
    background: var(--incoming);
  }

  .m.me .bub {
    color: white;
    background: linear-gradient(135deg, #6366f1, #4f46e5);
    border-radius: 18px 18px 5px 18px;
    box-shadow: 0 5px 15px rgba(79,70,229,.18);
  }

  .meta {
    font-size: 10px;
    color: #a0a7b2;
    margin-top: 5px;
  }

  /* MESSAGE INPUT */

  .send {
    display: flex;
    gap: 10px;
    align-items: center;
    padding: 15px 22px 18px;
    border-top: 1px solid var(--border);
    background: white;
  }

  #message {
    flex: 1;
    height: 46px;
    padding: 0 18px;
    border: 1px solid var(--border);
    border-radius: 14px;
    outline: none;
    background: #f8f9fb;
    color: #111827;
    font-size: 14px;
    transition: .2s;
  }

  #message:focus {
    border-color: #818cf8;
    background: white;
    box-shadow: 0 0 0 3px rgba(99,102,241,.08);
  }

  #message::placeholder {
    color: #9ca3af;
  }

  .btn {
    width: 46px;
    height: 46px;
    border: 0;
    border-radius: 14px;
    cursor: pointer;
    color: white;
    background: linear-gradient(135deg, #6366f1, #4f46e5);
    font-size: 18px;
    display: flex;
    align-items: center;
    justify-content: center;
    box-shadow: 0 7px 18px rgba(79,70,229,.25);
    transition: .2s;
  }

  .btn:hover {
    transform: translateY(-1px);
    box-shadow: 0 9px 22px rgba(79,70,229,.35);
  }

  .btn:active {
    transform: scale(.95);
  }

  /* MOBILE */

  @media (max-width: 900px) {
    .app {
      width: 98vw;
      height: 94vh;
    }

    .nav {
      width: 70px;
      padding: 15px 8px;
    }

    .brand span,
    .who-info,
    .navitem span {
      display: none;
    }

    .brand {
      justify-content: center;
      padding: 5px 0 25px;
    }

    .who {
      justify-content: center;
      padding: 7px;
    }

    .navitem {
      justify-content: center;
      padding: 13px;
    }

    .list {
      width: 280px;
    }
  }

  @media (max-width: 650px) {
    .app {
      height: 100vh;
      width: 100vw;
      border-radius: 0;
    }

    .nav {
      display: none;
    }

    .list {
      width: 38%;
      min-width: 120px;
    }

    .list-header {
      padding: 18px 12px;
    }

    .list h2 {
      font-size: 18px;
    }

    .chat-count,
    .search-wrap {
      display: none;
    }

    .u {
      padding: 10px 5px;
      gap: 7px;
    }

    .u .av {
      width: 36px;
      height: 36px;
      font-size: 13px;
    }

    .un {
      font-size: 12px;
    }

    .ul,
    .ud {
      display: none;
    }

    #box {
      padding: 18px 14px;
    }

    .m {
      max-width: 85%;
    }

    .send {
      padding: 10px;
    }
  }
</style>
</head>

<body>

<div class="app">

  <!-- SIDEBAR -->
  <div class="nav">

    <div class="brand">
      <div class="brand-icon">✦</div>
      <span>Chatly</span>
    </div>

    <div class="who">
      <div class="av" id="meAv" style="width:38px;height:38px"></div>

      <div class="who-info">
        <div class="who-name" id="me"><%= safe %></div>
        <div class="online">
          <span class="online-dot"></span>
          Online
        </div>
      </div>
    </div>

    <div class="nav-links">
      <a class="navitem active">
        <span>💬</span>
        <span>Chats</span>
      </a>
    </div>

    <div class="nav-bottom">
      <a class="navitem" href="LoginServlet">
        <span>↪</span>
        <span>Logout</span>
      </a>
    </div>

  </div>


  <!-- USERS -->
  <div class="list">

    <div class="list-header">

      <div class="list-title">
        <h2>Messages</h2>
        <div class="chat-count" id="chatCount">0</div>
      </div>

      <div class="search-wrap">
        <span class="search-icon">⌕</span>
        <input id="search" placeholder="Search conversations" oninput="renderUsers()">
      </div>

    </div>

    <div id="users"></div>

  </div>


  <!-- CHAT -->
  <div class="chat">

    <div class="head" id="head">
      <div class="hs">Select a conversation to start messaging</div>
    </div>

    <div id="box">
      <div class="empty">
        💬<br><br>
        Select someone from your conversations
      </div>
    </div>

    <div class="send">

      <input
        id="message"
        placeholder="Type a message..."
        onkeydown="if(event.key==='Enter') sendMessage()"
      >

      <button
        class="btn"
        onclick="sendMessage()"
        aria-label="Send"
      >
        ➤
      </button>

    </div>

  </div>

</div>


<script>
  const me  = document.getElementById("me").textContent;
  const box = document.getElementById("box");

  let current = null;
  let users = [];


  function esc(s) {
    const d = document.createElement("div");
    d.textContent = s;
    return d.innerHTML;
  }


  function escA(s) {
    return esc(s).replace(/"/g, "&quot;");
  }


  function hue(n) {
    let h = 0;

    for (const c of n) {
      h = (h * 31 + c.charCodeAt(0)) % 360;
    }

    return h;
  }


  function av(n) {
    return '<div class="av" style="background:hsl(' +
      hue(n) +
      ',65%,52%)">' +
      esc(n.charAt(0).toUpperCase()) +
      '</div>';
  }


  document.getElementById("meAv").outerHTML =
    av(me)
      .replace(
        'class="av"',
        'class="av" style="width:38px;height:38px;"'
      )
      .replace(
        'style="background',
        'data-x="" style="width:38px;height:38px;background'
      );


  function loadUsers() {

    fetch("GetUsersServlet")
      .then(r => r.json())
      .then(list => {
        users = list;

        document.getElementById("chatCount").textContent =
          list.length;

        renderUsers();
      })
      .catch(console.error);
  }


  function renderUsers() {

    const q =
      document
        .getElementById("search")
        .value
        .trim()
        .toLowerCase();

    document.getElementById("users").innerHTML = users
      .filter(u =>
        u.username.toLowerCase().includes(q)
      )
      .map(u =>

        '<div class="u ' +
          (u.username === current ? 'sel' : '') +
          '" data-u="' +
          escA(u.username) +
        '">' +

          av(u.username) +

          '<div class="ut">' +

            '<div class="un">' +
              esc(u.username) +
            '</div>' +

            '<div class="ul">' +
              esc(u.last || 'No messages yet') +
            '</div>' +

          '</div>' +

          '<div class="ud">' +
            esc(u.time ? u.time.slice(11, 16) : '') +
          '</div>' +

        '</div>'

      ).join("");
  }


  document
    .getElementById("users")
    .addEventListener("click", e => {

      const row = e.target.closest(".u");

      if (row) {
        selectUser(row.dataset.u);
      }

    });


  function selectUser(name) {

    current = name;

    document.getElementById("head").innerHTML =

      av(name) +

      '<div>' +

        '<div class="hn">' +
          esc(name) +
        '</div>' +

        '<div class="hs">Direct message</div>' +

      '</div>';

    renderUsers();

    loadMessages(true);

    document
      .getElementById("message")
      .focus();
  }


  function loadMessages(force) {

    if (!current) return;

    fetch(
      "GetMessagesServlet?receiver=" +
      encodeURIComponent(current)
    )

      .then(r => r.json())

      .then(list => {

        const atBottom =
          force ||
          box.scrollTop +
          box.clientHeight >=
          box.scrollHeight - 30;

        box.innerHTML = list.length

          ? list.map(m =>

              '<div class="m ' +
                (m.sender === me ? 'me' : '') +
              '">' +

                '<div class="bub">' +
                  esc(m.message) +
                '</div>' +

                '<div class="meta">' +
                  esc(m.sender) +
                  ' → ' +
                  esc(m.receiver) +
                  ' · ' +
                  esc(m.time.split('.')[0]) +
                '</div>' +

              '</div>'

            ).join("")

          : '<div class="empty">No messages yet.<br><br>Say hello 👋</div>';


        if (atBottom) {
          box.scrollTop = box.scrollHeight;
        }

      })

      .catch(console.error);
  }


  function sendMessage() {

    const input =
      document.getElementById("message");

    const message =
      input.value.trim();

    if (!current || !message) return;

    fetch("SendMessageServlet", {

      method: "POST",

      headers: {
        "Content-Type":
          "application/x-www-form-urlencoded"
      },

      body:
        "receiver=" +
        encodeURIComponent(current) +
        "&message=" +
        encodeURIComponent(message)

    })

    .then(() => {

      input.value = "";

      loadMessages(true);

      loadUsers();

    });

  }


  loadUsers();

  setInterval(loadMessages, 2000);

  setInterval(loadUsers, 3000);
</script>

</body>
</html>
