<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%--
  KIRA — Asistente Virtual · SaludBoyacá
  Incluir antes de </body>:
  <%@ include file="/WEB-INF/views/componentes/kira.jsp" %>
--%>
<%
  String kiraLang   = (String) session.getAttribute("lang");
  String kiraRol    = (String) session.getAttribute("usuarioRol");
  String kiraNombre = (String) session.getAttribute("usuarioNombre");
  if (kiraLang   == null) kiraLang   = "es";
  if (kiraRol    == null) kiraRol    = "PUBLICO";
  if (kiraNombre == null) kiraNombre = "";
%>

<style>
#kira-root {
  --kw : #561C24; --kw2: #6D2932; --kw3: #3a1520;
  --kcr: #E8D8C4; --ksd: #C7B7A3; --kwh: #fdfaf7;
  --ktx: #2C1810; --km : #8B7355;
  --kb : rgba(199,183,163,.35);
  --ks : rgba(86,28,36,.18);
  font-family: 'Lato','DM Sans',sans-serif;
}
#kira-btn {
  position:fixed; bottom:28px; right:28px;
  width:62px; height:62px; border-radius:50%;
  background:linear-gradient(145deg,var(--kw),var(--kw2));
  border:none; cursor:pointer;
  box-shadow:0 8px 32px var(--ks),0 2px 8px rgba(0,0,0,.15);
  display:flex; align-items:center; justify-content:center;
  z-index:9998;
  transition:transform .3s cubic-bezier(.34,1.56,.64,1),box-shadow .3s;
  animation:kira-pulse 3s infinite;
}
#kira-btn:hover { transform:scale(1.12); }
#kira-btn svg { width:30px; height:30px; fill:var(--kwh); transition:transform .3s; }
#kira-btn.open svg { transform:rotate(45deg); }
#kira-badge {
  position:absolute; top:-4px; right:-4px;
  width:18px; height:18px; border-radius:50%;
  background:#e74c3c; color:#fff;
  font-size:10px; font-weight:800;
  display:flex; align-items:center; justify-content:center;
  border:2px solid #fff;
  animation:kira-bounce .6s infinite alternate;
}
@keyframes kira-pulse {
  0%,100%{ box-shadow:0 8px 32px var(--ks),0 0 0 0 rgba(86,28,36,.4); }
  50%    { box-shadow:0 8px 32px var(--ks),0 0 0 10px rgba(86,28,36,0); }
}
@keyframes kira-bounce { from{transform:translateY(0)} to{transform:translateY(-3px)} }

#kira-window {
  position:fixed; bottom:104px; right:28px;
  width:380px; max-width:calc(100vw - 40px);
  height:560px; max-height:calc(100vh - 140px);
  background:var(--kwh); border-radius:20px;
  box-shadow:0 24px 72px rgba(86,28,36,.28),0 4px 16px rgba(0,0,0,.1);
  display:flex; flex-direction:column;
  z-index:9999;
  transform:scale(.85) translateY(24px);
  opacity:0; pointer-events:none;
  transform-origin:bottom right;
  transition:transform .35s cubic-bezier(.34,1.2,.64,1),opacity .3s;
  overflow:hidden;
}
#kira-window.kira-open {
  transform:scale(1) translateY(0);
  opacity:1; pointer-events:all;
}
#kira-header {
  background:linear-gradient(135deg,var(--kw) 0%,var(--kw2) 60%,var(--kw3) 100%);
  padding:14px 16px;
  display:flex; align-items:center; gap:12px;
  position:relative; overflow:hidden; flex-shrink:0;
}
#kira-header::before {
  content:''; position:absolute; right:-30px; top:-30px;
  width:100px; height:100px; border-radius:50%;
  background:rgba(255,255,255,.06);
}
.kira-av {
  width:44px; height:44px; border-radius:50%;
  background:rgba(255,255,255,.15);
  border:2px solid rgba(255,255,255,.35);
  display:flex; align-items:center; justify-content:center;
  flex-shrink:0; position:relative; overflow:hidden;
}
.kira-av::after {
  content:''; position:absolute; bottom:1px; right:1px;
  width:10px; height:10px; border-radius:50%;
  background:#2ecc71; border:2px solid #fff;
}
.kira-av svg { width:26px; height:26px; fill:#fff; }
.kira-hi { flex:1; }
.kira-name   { color:#fff; font-weight:700; font-size:.95rem; margin:0; }
.kira-status { color:rgba(232,216,196,.8); font-size:.72rem; margin:2px 0 0; }
.kira-hacts  { display:flex; gap:6px; }
.kira-hbtn {
  background:rgba(255,255,255,.12); border:none;
  color:rgba(255,255,255,.85); border-radius:8px;
  width:32px; height:32px; cursor:pointer;
  display:flex; align-items:center; justify-content:center;
  font-size:.9rem; font-weight:700;
  transition:background .2s; flex-shrink:0;
  line-height:1;
}
.kira-hbtn:hover { background:rgba(255,255,255,.28); color:#fff; }

#kira-lang-bar {
  background:linear-gradient(135deg,var(--kw),var(--kw2));
  display:flex; gap:6px; padding:8px 16px; flex-shrink:0;
}
.kira-lang-pill {
  background:rgba(255,255,255,.1);
  border:1px solid rgba(255,255,255,.2);
  color:rgba(232,216,196,.8); border-radius:20px;
  padding:3px 11px; font-size:.68rem; font-weight:700;
  cursor:pointer; transition:all .2s;
}
.kira-lang-pill.kira-lang-active {
  background:rgba(255,255,255,.28); color:#fff;
  border-color:rgba(255,255,255,.45);
}
.kira-lang-pill:hover:not(.kira-lang-active) {
  background:rgba(255,255,255,.18); color:rgba(255,255,255,.95);
}

#kira-messages {
  flex:1; overflow-y:auto; padding:14px 12px;
  display:flex; flex-direction:column; gap:10px;
  scroll-behavior:smooth;
}
#kira-messages::-webkit-scrollbar { width:4px; }
#kira-messages::-webkit-scrollbar-thumb { background:var(--kb); border-radius:4px; }

.kira-msg { display:flex; gap:8px; align-items:flex-end; animation:kira-msgIn .3s ease both; }
@keyframes kira-msgIn { from{ opacity:0; transform:translateY(10px); } to{ opacity:1; transform:translateY(0); } }
.kira-msg.kira-user { flex-direction:row-reverse; }

.kira-msg-av {
  width:28px; height:28px; border-radius:50%; flex-shrink:0;
  background:linear-gradient(135deg,var(--kw),var(--kw2));
  display:flex; align-items:center; justify-content:center;
}
.kira-msg-av svg { width:16px; height:16px; fill:#fff; }
.kira-msg.kira-user .kira-msg-av {
  background:var(--kcr); color:var(--kw);
  font-size:11px; font-weight:800;
}

.kira-bubble {
  max-width:78%; padding:10px 14px;
  border-radius:18px; font-size:.86rem; line-height:1.55; word-break:break-word;
}
.kira-msg.kira-bot  .kira-bubble {
  background:#fff; color:var(--ktx);
  border:1px solid var(--kb); border-bottom-left-radius:4px;
  box-shadow:0 2px 8px rgba(86,28,36,.07);
}
.kira-msg.kira-user .kira-bubble {
  background:linear-gradient(135deg,var(--kw),var(--kw2));
  color:#fff; border-bottom-right-radius:4px;
}
.kira-bubble strong { font-weight:700; }
.kira-bubble em { font-style:italic; opacity:.85; }

.kira-typing {
  display:flex; gap:5px; align-items:center;
  padding:10px 14px; background:#fff;
  border:1px solid var(--kb); border-radius:18px;
  border-bottom-left-radius:4px; width:fit-content;
  box-shadow:0 2px 8px rgba(86,28,36,.07);
}
.kira-typing span { width:7px; height:7px; border-radius:50%; background:var(--ksd); display:inline-block; }
.kira-typing span:nth-child(1){ animation:kira-dot .9s .0s infinite; }
.kira-typing span:nth-child(2){ animation:kira-dot .9s .2s infinite; }
.kira-typing span:nth-child(3){ animation:kira-dot .9s .4s infinite; }
@keyframes kira-dot { 0%,80%,100%{ transform:translateY(0); opacity:.5; } 40%{ transform:translateY(-6px); opacity:1; } }

.kira-chips { display:flex; flex-wrap:wrap; gap:6px; padding:4px 12px 6px; }
.kira-chip {
  background:#fff; border:1.5px solid var(--kb);
  color:var(--kw); border-radius:20px;
  padding:6px 13px; font-size:.79rem; font-weight:600;
  cursor:pointer; transition:all .2s;
  box-shadow:0 2px 6px rgba(86,28,36,.07); white-space:nowrap;
}
.kira-chip:hover {
  background:var(--kw); color:#fff; border-color:var(--kw);
  transform:translateY(-1px); box-shadow:0 4px 12px rgba(86,28,36,.22);
}

#kira-input-area {
  padding:10px 12px 12px;
  border-top:1px solid var(--kb);
  background:var(--kwh); flex-shrink:0;
}
.kira-input-row {
  display:flex; gap:8px; align-items:center;
  background:#fff; border:2px solid var(--kb);
  border-radius:13px; padding:6px 6px 6px 13px;
  transition:border-color .25s,box-shadow .25s;
}
.kira-input-row:focus-within { border-color:var(--kw); box-shadow:0 0 0 3px rgba(86,28,36,.1); }
#kira-input {
  flex:1; border:none; outline:none;
  font-size:.88rem; color:var(--ktx);
  background:transparent; font-family:inherit;
  resize:none; max-height:80px; line-height:1.4;
}
#kira-input::placeholder { color:var(--ksd); }
#kira-send {
  width:36px; height:36px; border-radius:10px;
  background:linear-gradient(135deg,var(--kw),var(--kw2));
  border:none; cursor:pointer;
  display:flex; align-items:center; justify-content:center;
  flex-shrink:0; transition:all .2s;
}
#kira-send:hover { transform:scale(1.08); box-shadow:0 4px 14px rgba(86,28,36,.35); }
#kira-send svg { width:16px; height:16px; fill:#fff; }
#kira-footer { text-align:center; padding:5px 0 9px; font-size:.65rem; color:var(--km); }

@media(max-width:440px){
  #kira-window{ right:10px; bottom:88px; width:calc(100vw - 20px); }
  #kira-btn   { right:14px; bottom:14px; }
}
</style>

<div id="kira-root">
  <button id="kira-btn" title="Kira">
    <div id="kira-badge">1</div>
    <svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
      <path d="M12 2C9.243 2 7 4.243 7 7s2.243 5 5 5 5-2.243 5-5-2.243-5-5-5zM12 10c-1.654 0-3-1.346-3-3s1.346-3 3-3 3 1.346 3 3-1.346 3-3 3zM21 21v-1c0-3.859-3.141-7-7-7h-4c-3.859 0-7 3.141-7 7v1h2v-1c0-2.757 2.243-5 5-5h4c2.757 0 5 2.243 5 5v1h2zM16 11h2v2h2v2h-2v2h-2v-2h-2v-2h2z"/>
    </svg>
  </button>

  <div id="kira-window">
    <div id="kira-header">
      <div class="kira-av">
        <svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
          <path d="M12 2C9.243 2 7 4.243 7 7s2.243 5 5 5 5-2.243 5-5-2.243-5-5-5zM12 10c-1.654 0-3-1.346-3-3s1.346-3 3-3 3 1.346 3 3-1.346 3-3 3zM21 21v-1c0-3.859-3.141-7-7-7h-4c-3.859 0-7 3.141-7 7v1h2v-1c0-2.757 2.243-5 5-5h4c2.757 0 5 2.243 5 5v1h2zM16 11h2v2h2v2h-2v2h-2v-2h-2v-2h2z"/>
        </svg>
      </div>
      <div class="kira-hi">
        <div class="kira-name">Kira</div>
        <div class="kira-status" id="kira-status-txt">● En línea</div>
      </div>
      <div class="kira-hacts">
        <button class="kira-hbtn" id="kira-btn-restart" title="Reiniciar">↺</button>
        <button class="kira-hbtn" id="kira-btn-close"   title="Cerrar">✕</button>
      </div>
    </div>

    <div id="kira-lang-bar">
      <button class="kira-lang-pill" data-lang="es">🇨🇴 ES</button>
      <button class="kira-lang-pill" data-lang="en">🇺🇸 EN</button>
      <button class="kira-lang-pill" data-lang="it">🇮🇹 IT</button>
    </div>

    <div id="kira-messages"></div>
    <div class="kira-chips" id="kira-chips"></div>

    <div id="kira-input-area">
      <div class="kira-input-row">
        <textarea id="kira-input" rows="1" placeholder="Escribe algo..."></textarea>
        <button id="kira-send">
          <svg viewBox="0 0 24 24"><path d="M2.01 21L23 12 2.01 3 2 10l15 2-15 2z"/></svg>
        </button>
      </div>
    </div>
    <div id="kira-footer">SaludBoyacá · SENA CIMM 2026</div>
  </div>
</div>

<script>
var KIRA = {
  lang  : '<%= kiraLang %>',
  rol   : '<%= kiraRol %>',
  nombre: '<%= kiraNombre %>',
  state : 'menu',
  open  : false
};

var KIRA_T = {
  es:{
    status:'● En línea', placeholder:'Escribe algo...',
    bienvenida_PUBLICO:'¡Hola! 👋 Soy **Kira**, la asistente virtual de **SaludBoyacá**.\n\n¿En qué puedo ayudarte hoy?',
    bienvenida_RECEPCIONISTA:'¡Hola, {n}! 👋 Soy **Kira**.\nEstás como **Recepcionista**. ¿En qué te ayudo?',
    bienvenida_MEDICO:'Bienvenido/a, Dr(a). **{n}** 👋 Soy **Kira**.\nEstás como **Médico**. ¿Qué necesitas?',
    bienvenida_ENFERMERO:'¡Hola, **{n}**! 👋 Soy **Kira**.\nEstás como **Enfermero/a**. ¿En qué te apoyo?',
    menu_PUBLICO:[{l:'📋 Consultar mi cita',id:'consultar_cita'},{l:'🏥 Servicios',id:'servicios'},{l:'🕐 Horarios médicos',id:'horarios'},{l:'📝 ¿Cómo saco una cita?',id:'como_sacar'},{l:'📞 Contacto',id:'contacto'}],
    menu_RECEPCIONISTA:[{l:'📋 Consultar cita',id:'consultar_cita'},{l:'👥 Gestión pacientes',id:'guia_pacientes'},{l:'📅 Gestión citas',id:'guia_citas'},{l:'🏥 Servicios',id:'servicios'},{l:'📞 Contacto',id:'contacto'}],
    menu_MEDICO:[{l:'📋 Consultar cita',id:'consultar_cita'},{l:'📅 Mis citas del día',id:'citas_dia'},{l:'🔄 Estados de cita',id:'estados_cita'},{l:'🕐 Horarios',id:'horarios'},{l:'📞 Contacto',id:'contacto'}],
    menu_ENFERMERO:[{l:'📋 Consultar cita',id:'consultar_cita'},{l:'🏥 Servicios',id:'servicios'},{l:'🕐 Horarios',id:'horarios'},{l:'📞 Contacto',id:'contacto'}],
    pedir_doc:'🔍 Ingresa el **número de documento** del paciente:',
    doc_invalido:'⚠️ El documento debe tener entre 5 y 15 dígitos numéricos. Intenta de nuevo.',
    doc_ok:'✅ Documento **{d}** recibido.\n\nPara ver el estado real de la cita dirígete a:\n📋 **Menú → Consulta de Cita**\no inicia sesión en el sistema.',
    volver:'↩ Volver al menú',
    no_entiendo:'🤔 No entendí eso. Elige una opción:',
    servicios:'🏥 **Nuestros servicios:**\n\n🩺 **Medicina General** — Atención para toda la familia\n👶 **Pediatría** — Cuidado infantil y adolescente\n👩‍⚕️ **Ginecología** — Salud integral de la mujer\n🦷 **Odontología** — Salud oral\n👁️ **Optometría** — Exámenes de la vista\n📄 **Certificados Médicos** — Comprobantes y certificados',
    horarios:'🕐 **Horarios de atención:**\n\n📅 Lunes a Viernes\n🕖 Mañana: 7:00 AM – 12:00 PM\n🕑 Tarde: 2:00 PM – 5:00 PM\n\n_Para horario de médico específico ve a la sección **Horarios** del sistema._',
    como_sacar:'📝 **¿Cómo sacar una cita?**\n\n**Paciente registrado:**\n1️⃣ Inicia sesión\n2️⃣ Menú → Citas → Nueva Cita\n3️⃣ Selecciona especialidad, médico y fecha\n4️⃣ Confirma y descarga tu PDF\n\n**Paciente nuevo:**\n1️⃣ Acércate a la recepción\n2️⃣ El recepcionista te registrará\n3️⃣ Luego gestiona tus citas en línea',
    contacto:'📞 **Contacto**\n\n🏥 Centro de Salud Municipal de Paipa, Boyacá\n📍 Paipa, Boyacá, Colombia\n🕐 Lun–Vie: 7:00 AM – 5:00 PM\n\n🎓 _SENA · CIMM · Regional Boyacá · 2026_',
    guia_pacientes:'👥 **Gestión de Pacientes (Recepcionista)**\n\n➕ **Nuevo:** Menú → Pacientes → Nuevo Paciente\n✏️ **Editar:** Lista → clic en ✏️\n🗑️ **Eliminar:** Solo Recepcionista\n🔍 **Buscar:** Por nombre, documento o EPS\n📸 **Foto:** JPG/PNG máx. 2 MB',
    guia_citas:'📅 **Gestión de Citas (Recepcionista)**\n\n➕ Nueva: Menú → Citas → Nueva Cita\n  1. Paciente → 2. Especialidad → médico → fecha\n  3. Sistema valida disponibilidad automáticamente\n\n✏️ Editar: solo citas *Programadas*\n📄 PDF: desde el detalle de la cita',
    estados_cita:'🔄 **Estados de cita (Médico)**\n\n🟡 **Programada** → Confirmar o Cancelar\n🟢 **Confirmada** → Marcar como Atendida\n✅ **Atendida** → Estado final\n🔴 **Cancelada** → Estado final\n\n_Desde: Citas → Ver detalle_',
    citas_dia:'📅 Para ver tus citas de hoy:\n\n**Menú → Citas Médicas**\n\n🟢 Filtro **"Confirmada"** → listas para atender\n🟡 Filtro **"Programada"** → pendientes de confirmar'
  },
  en:{
    status:'● Online', placeholder:'Type something...',
    bienvenida_PUBLICO:'Hello! 👋 I\'m **Kira**, SaludBoyacá\'s virtual assistant.\n\nHow can I help you today?',
    bienvenida_RECEPCIONISTA:'Hello, {n}! 👋 I\'m **Kira**.\nLogged in as **Receptionist**. How can I help?',
    bienvenida_MEDICO:'Welcome, Dr. **{n}** 👋 I\'m **Kira**.\nLogged in as **Doctor**. What do you need?',
    bienvenida_ENFERMERO:'Hello, **{n}**! 👋 I\'m **Kira**.\nLogged in as **Nurse**. How can I assist?',
    menu_PUBLICO:[{l:'📋 Check my appointment',id:'consultar_cita'},{l:'🏥 Services',id:'servicios'},{l:'🕐 Doctor schedules',id:'horarios'},{l:'📝 How to book?',id:'como_sacar'},{l:'📞 Contact',id:'contacto'}],
    menu_RECEPCIONISTA:[{l:'📋 Check appointment',id:'consultar_cita'},{l:'👥 Patient management',id:'guia_pacientes'},{l:'📅 Appointment management',id:'guia_citas'},{l:'🏥 Services',id:'servicios'},{l:'📞 Contact',id:'contacto'}],
    menu_MEDICO:[{l:'📋 Check appointment',id:'consultar_cita'},{l:'📅 Today\'s appointments',id:'citas_dia'},{l:'🔄 Appointment statuses',id:'estados_cita'},{l:'🕐 Schedules',id:'horarios'},{l:'📞 Contact',id:'contacto'}],
    menu_ENFERMERO:[{l:'📋 Check appointment',id:'consultar_cita'},{l:'🏥 Services',id:'servicios'},{l:'🕐 Schedules',id:'horarios'},{l:'📞 Contact',id:'contacto'}],
    pedir_doc:'🔍 Enter the patient\'s **ID number**:',
    doc_invalido:'⚠️ The ID must have between 5 and 15 numeric digits. Try again.',
    doc_ok:'✅ ID **{d}** received.\n\nTo check the real appointment status go to:\n📋 **Menu → Appointment Lookup**\nor log in to the system.',
    volver:'↩ Back to menu',
    no_entiendo:'🤔 I didn\'t understand that. Please choose an option:',
    servicios:'🏥 **Our services:**\n\n🩺 **General Medicine** — Care for the whole family\n👶 **Pediatrics** — Children and adolescent care\n👩‍⚕️ **Gynecology** — Women\'s health\n🦷 **Dentistry** — Oral health\n👁️ **Optometry** — Eye exams\n📄 **Medical Certificates** — Receipts and certificates',
    horarios:'🕐 **Attendance schedules:**\n\n📅 Monday to Friday\n🕖 Morning: 7:00 AM – 12:00 PM\n🕑 Afternoon: 2:00 PM – 5:00 PM\n\n_For a specific doctor\'s schedule, check the **Schedules** section._',
    como_sacar:'📝 **How to book an appointment?**\n\n**Registered patient:**\n1️⃣ Log in\n2️⃣ Menu → Appointments → New Appointment\n3️⃣ Select specialty, doctor and date\n4️⃣ Confirm and download your PDF\n\n**New patient:**\n1️⃣ Visit the reception\n2️⃣ Receptionist will register you\n3️⃣ Then manage appointments online',
    contacto:'📞 **Contact**\n\n🏥 Municipal Health Center of Paipa, Boyacá\n📍 Paipa, Boyacá, Colombia\n🕐 Mon–Fri: 7:00 AM – 5:00 PM\n\n🎓 _SENA · CIMM · Regional Boyacá · 2026_',
    guia_pacientes:'👥 **Patient Management (Receptionist)**\n\n➕ New: Menu → Patients → New Patient\n✏️ Edit: List → click ✏️\n🗑️ Delete: Only Receptionist\n🔍 Search: By name, ID or insurance\n📸 Photo: JPG/PNG max 2 MB',
    guia_citas:'📅 **Appointment Management (Receptionist)**\n\n➕ New: Menu → Appointments → New\n  1. Patient → 2. Specialty → doctor → date\n  3. System validates availability automatically\n\n✏️ Edit: only *Scheduled* appointments\n📄 PDF: from appointment detail',
    estados_cita:'🔄 **Appointment statuses (Doctor)**\n\n🟡 **Scheduled** → Confirm or Cancel\n🟢 **Confirmed** → Mark as Attended\n✅ **Attended** → Final status\n🔴 **Cancelled** → Final status\n\n_From: Appointments → View detail_',
    citas_dia:'📅 To see today\'s appointments:\n\n**Menu → Medical Appointments**\n\n🟢 Filter **"Confirmed"** → ready to attend\n🟡 Filter **"Scheduled"** → pending confirmation'
  },
  it:{
    status:'● Online', placeholder:'Scrivi qualcosa...',
    bienvenida_PUBLICO:'Ciao! 👋 Sono **Kira**, l\'assistente virtuale di **SaludBoyacá**.\n\nCome posso aiutarti oggi?',
    bienvenida_RECEPCIONISTA:'Ciao, {n}! 👋 Sono **Kira**.\nSei connesso come **Receptionist**. Come posso aiutarti?',
    bienvenida_MEDICO:'Benvenuto/a, Dott. **{n}** 👋 Sono **Kira**.\nSei come **Medico**. Cosa ti serve?',
    bienvenida_ENFERMERO:'Ciao, **{n}**! 👋 Sono **Kira**.\nSei come **Infermiere/a**. Come posso assisterti?',
    menu_PUBLICO:[{l:'📋 Controlla appuntamento',id:'consultar_cita'},{l:'🏥 Servizi',id:'servicios'},{l:'🕐 Orari medici',id:'horarios'},{l:'📝 Come prenotare?',id:'como_sacar'},{l:'📞 Contatto',id:'contacto'}],
    menu_RECEPCIONISTA:[{l:'📋 Controlla appuntamento',id:'consultar_cita'},{l:'👥 Gestione pazienti',id:'guia_pacientes'},{l:'📅 Gestione appuntamenti',id:'guia_citas'},{l:'🏥 Servizi',id:'servicios'},{l:'📞 Contatto',id:'contacto'}],
    menu_MEDICO:[{l:'📋 Controlla appuntamento',id:'consultar_cita'},{l:'📅 Appuntamenti oggi',id:'citas_dia'},{l:'🔄 Stati appuntamento',id:'estados_cita'},{l:'🕐 Orari',id:'horarios'},{l:'📞 Contatto',id:'contacto'}],
    menu_ENFERMERO:[{l:'📋 Controlla appuntamento',id:'consultar_cita'},{l:'🏥 Servizi',id:'servicios'},{l:'🕐 Orari',id:'horarios'},{l:'📞 Contatto',id:'contacto'}],
    pedir_doc:'🔍 Inserisci il **numero documento** del paziente:',
    doc_invalido:'⚠️ Il documento deve avere tra 5 e 15 cifre numeriche. Riprova.',
    doc_ok:'✅ Documento **{d}** ricevuto.\n\nPer controllare lo stato reale vai a:\n📋 **Menu → Ricerca Appuntamento**\no accedi al sistema.',
    volver:'↩ Torna al menu',
    no_entiendo:'🤔 Non ho capito. Scegli un\'opzione:',
    servicios:'🏥 **I nostri servizi:**\n\n🩺 **Medicina Generale** — Assistenza per tutta la famiglia\n👶 **Pediatria** — Cura bambini e adolescenti\n👩‍⚕️ **Ginecologia** — Salute della donna\n🦷 **Odontoiatria** — Salute orale\n👁️ **Optometria** — Esami della vista\n📄 **Certificati Medici** — Ricevute e certificati',
    horarios:'🕐 **Orari di attenzione:**\n\n📅 Lunedì–Venerdì\n🕖 Mattina: 7:00 – 12:00\n🕑 Pomeriggio: 14:00 – 17:00\n\n_Per l\'orario di un medico specifico consulta la sezione **Orari**._',
    como_sacar:'📝 **Come prenotare un appuntamento?**\n\n**Paziente registrato:**\n1️⃣ Accedi\n2️⃣ Menu → Appuntamenti → Nuovo\n3️⃣ Seleziona specialità, medico e data\n4️⃣ Conferma e scarica il PDF\n\n**Nuovo paziente:**\n1️⃣ Vai alla reception\n2️⃣ Il receptionist ti registrerà\n3️⃣ Poi gestisci online',
    contacto:'📞 **Contatto**\n\n🏥 Centro Salute Municipale di Paipa, Boyacá\n📍 Paipa, Boyacá, Colombia\n🕐 Lun–Ven: 7:00 – 17:00\n\n🎓 _SENA · CIMM · Regional Boyacá · 2026_',
    guia_pacientes:'👥 **Gestione Pazienti (Receptionist)**\n\n➕ Nuovo: Menu → Pazienti → Nuovo Paziente\n✏️ Modifica: Lista → clicca ✏️\n🗑️ Elimina: Solo Receptionist\n🔍 Cerca: Per nome, documento o assicurazione\n📸 Foto: JPG/PNG max 2 MB',
    guia_citas:'📅 **Gestione Appuntamenti (Receptionist)**\n\n➕ Nuovo: Menu → Appuntamenti → Nuovo\n  1. Paziente → 2. Specialità → medico → data\n  3. Il sistema verifica disponibilità automaticamente\n\n✏️ Modifica: solo *Programmati*\n📄 PDF: dal dettaglio appuntamento',
    estados_cita:'🔄 **Stati appuntamento (Medico)**\n\n🟡 **Programmata** → Confermare o Cancellare\n🟢 **Confermata** → Marcare come Visitata\n✅ **Visitata** → Stato finale\n🔴 **Cancellata** → Stato finale\n\n_Da: Appuntamenti → Vedi dettaglio_',
    citas_dia:'📅 Per vedere gli appuntamenti di oggi:\n\n**Menu → Appuntamenti Medici**\n\n🟢 Filtro **"Confermata"** → pronti per oggi\n🟡 Filtro **"Programmata"** → in attesa di conferma'
  }
};

/* ── Helpers ── */
function kEl(id){ return document.getElementById(id); }
function kT(key){
  var d = KIRA_T[KIRA.lang] || KIRA_T.es;
  return d[key] !== undefined ? d[key] : (KIRA_T.es[key] || '');
}
function kMenu(){
  var d = KIRA_T[KIRA.lang] || KIRA_T.es;
  return d['menu_'+KIRA.rol] || d.menu_PUBLICO || [];
}
function kBienvenida(){
  var txt = kT('bienvenida_'+KIRA.rol) || kT('bienvenida_PUBLICO');
  return txt.replace(/{n}/g, KIRA.nombre || '');
}
function kMd(t){
  return t.replace(/\*\*(.+?)\*\*/g,'<strong>$1</strong>')
          .replace(/\*(.+?)\*/g,'<em>$1</em>')
          .replace(/\n/g,'<br>');
}

var KIRA_ICON = '<svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path d="M12 2C9.243 2 7 4.243 7 7s2.243 5 5 5 5-2.243 5-5-2.243-5-5-5zM12 10c-1.654 0-3-1.346-3-3s1.346-3 3-3 3 1.346 3 3-1.346 3-3 3zM21 21v-1c0-3.859-3.141-7-7-7h-4c-3.859 0-7 3.141-7 7v1h2v-1c0-2.757 2.243-5 5-5h4c2.757 0 5 2.243 5 5v1h2zM16 11h2v2h2v2h-2v2h-2v-2h-2v-2h2z"/></svg>';

function kAddMsg(txt, who){
  var msgs = kEl('kira-messages');
  var wrap = document.createElement('div');
  wrap.className = 'kira-msg kira-'+who;
  var av = document.createElement('div');
  av.className = 'kira-msg-av';
  if(who==='bot'){ av.innerHTML = KIRA_ICON; }
  else { av.textContent = KIRA.nombre ? KIRA.nombre.charAt(0).toUpperCase() : '?'; }
  var bub = document.createElement('div');
  bub.className = 'kira-bubble';
  bub.innerHTML = kMd(txt);
  wrap.appendChild(av); wrap.appendChild(bub);
  msgs.appendChild(wrap);
  msgs.scrollTop = msgs.scrollHeight;
}

function kShowTyping(){
  var msgs = kEl('kira-messages');
  var wrap = document.createElement('div');
  wrap.className = 'kira-msg kira-bot'; wrap.id = 'kira-ty';
  var av = document.createElement('div'); av.className='kira-msg-av'; av.innerHTML=KIRA_ICON;
  var dot = document.createElement('div'); dot.className='kira-typing';
  dot.innerHTML='<span></span><span></span><span></span>';
  wrap.appendChild(av); wrap.appendChild(dot);
  msgs.appendChild(wrap); msgs.scrollTop = msgs.scrollHeight;
}
function kHideTyping(){ var e=kEl('kira-ty'); if(e) e.remove(); }

function kSetChips(items){
  var c = kEl('kira-chips'); c.innerHTML='';
  if(!items||!items.length) return;
  items.forEach(function(item){
    var btn = document.createElement('button');
    btn.className='kira-chip'; btn.textContent=item.l;
    btn.addEventListener('click', function(){ kHandle(item.id, item.l); });
    c.appendChild(btn);
  });
}

function kReply(txt, delay, chips){
  kShowTyping();
  setTimeout(function(){
    kHideTyping(); kAddMsg(txt,'bot'); kSetChips(chips||[]);
  }, delay||700);
}

/* ── Flujos ── */
function kHandle(id, label){
  kAddMsg(label,'user'); kSetChips([]); KIRA.state='menu';
  var back = [{l:kT('volver'), id:'volver_menu'}];
  switch(id){
    case 'consultar_cita': kReply(kT('pedir_doc'),500); KIRA.state='esperando_doc'; break;
    case 'servicios':      kReply(kT('servicios'),600,back); break;
    case 'horarios':       kReply(kT('horarios'),600,back); break;
    case 'como_sacar':     kReply(kT('como_sacar'),600,back); break;
    case 'contacto':       kReply(kT('contacto'),600,back); break;
    case 'guia_pacientes': kReply(kT('guia_pacientes'),600,back); break;
    case 'guia_citas':     kReply(kT('guia_citas'),600,back); break;
    case 'estados_cita':   kReply(kT('estados_cita'),600,back); break;
    case 'citas_dia':      kReply(kT('citas_dia'),600,back); break;
    case 'volver_menu': case 'menu': kShowMenu(); break;
    default: kReply(kT('no_entiendo'),500,kMenu());
  }
}

function kShowMenu(){
  KIRA.state='menu';
  kShowTyping();
  setTimeout(function(){ kHideTyping(); kSetChips(kMenu()); }, 400);
}

function kSend(){
  var inp = kEl('kira-input');
  var txt = inp.value.trim();
  if(!txt) return;
  inp.value=''; inp.style.height='';

  if(KIRA.state==='esperando_doc'){
    kAddMsg(txt,'user'); kSetChips([]);
    if(!/^\d{5,15}$/.test(txt)){ kReply(kT('doc_invalido'),500); return; }
    KIRA.state='menu';
    kReply(kT('doc_ok').replace(/{d}/g,txt), 600, [{l:kT('volver'),id:'volver_menu'}]);
    return;
  }

  kAddMsg(txt,'user');
  var lc = txt.toLowerCase();
  if(/cita|appointment|appuntamento|consultar|check|controlla/.test(lc))     kHandle('consultar_cita',txt);
  else if(/servicio|service|servizi/.test(lc))                               kHandle('servicios',txt);
  else if(/horario|schedule|orario/.test(lc))                                kHandle('horarios',txt);
  else if(/contact|contatto|contacto/.test(lc))                              kHandle('contacto',txt);
  else if(/como|how|come/.test(lc))                                          kHandle('como_sacar',txt);
  else if(/paciente|patient|paziente/.test(lc)&&KIRA.rol!=='PUBLICO')        kHandle('guia_pacientes',txt);
  else if(/estado|status|stato/.test(lc)&&KIRA.rol==='MEDICO')               kHandle('estados_cita',txt);
  else { kSetChips([]); kReply(kT('no_entiendo'),500,kMenu()); }
}

function kChangeLang(lang){
  KIRA.lang=lang;
  document.querySelectorAll('.kira-lang-pill').forEach(function(p){
    p.classList.toggle('kira-lang-active', p.getAttribute('data-lang')===lang);
  });
  kEl('kira-input').placeholder     = kT('placeholder');
  kEl('kira-status-txt').textContent = kT('status');
  kRestart(true);
}

function kToggle(){
  KIRA.open=!KIRA.open;
  kEl('kira-window').classList.toggle('kira-open', KIRA.open);
  kEl('kira-btn').classList.toggle('open', KIRA.open);
  if(KIRA.open){ kEl('kira-badge').style.display='none'; kEl('kira-input').focus(); }
}

function kRestart(silent){
  kEl('kira-messages').innerHTML=''; kEl('kira-chips').innerHTML='';
  KIRA.state='menu';
  if(silent){ kAddMsg(kBienvenida(),'bot'); kSetChips(kMenu()); return; }
  kShowTyping();
  setTimeout(function(){ kHideTyping(); kAddMsg(kBienvenida(),'bot'); kSetChips(kMenu()); }, 800);
}

/* ── Init: todo en DOMContentLoaded ── */
document.addEventListener('DOMContentLoaded', function(){
  /* Botón flotante */
  kEl('kira-btn').addEventListener('click', kToggle);
  /* Header */
  kEl('kira-btn-close').addEventListener('click', kToggle);
  kEl('kira-btn-restart').addEventListener('click', function(){ kRestart(false); });
  /* Lang pills */
  document.querySelectorAll('.kira-lang-pill').forEach(function(p){
    p.addEventListener('click', function(){ kChangeLang(p.getAttribute('data-lang')); });
    p.classList.toggle('kira-lang-active', p.getAttribute('data-lang')===KIRA.lang);
  });
  /* Input */
  kEl('kira-send').addEventListener('click', kSend);
  kEl('kira-input').addEventListener('keydown', function(e){
    if(e.key==='Enter'&&!e.shiftKey){ e.preventDefault(); kSend(); }
  });
  kEl('kira-input').addEventListener('input', function(){
    this.style.height=''; this.style.height=Math.min(this.scrollHeight,80)+'px';
  });
  /* Placeholder / status */
  kEl('kira-input').placeholder      = kT('placeholder');
  kEl('kira-status-txt').textContent = kT('status');
  /* Bienvenida */
  setTimeout(function(){
    kShowTyping();
    setTimeout(function(){ kHideTyping(); kAddMsg(kBienvenida(),'bot'); kSetChips(kMenu()); }, 900);
  }, 600);
});
</script>
