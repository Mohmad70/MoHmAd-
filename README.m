<!DOCTYPE html>
<html lang="ar">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>منصة إعلانات القفر</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      direction: rtl;
      background-color: #f0f0f0;
      padding: 20px;
    }
    .login-container, .app-container {
      max-width: 600px;
      margin: auto;
      background: white;
      padding: 20px;
      border-radius: 10px;
      box-shadow: 0 0 10px #ccc;
    }
    input, textarea, select, button {
      width: 100%;
      margin: 10px 0;
      padding: 10px;
      font-size: 16px;
    }
    .ad-card {
      border: 1px solid #ddd;
      background: #fff;
      margin-bottom: 20px;
      padding: 10px;
      border-radius: 8px;
    }
    .ad-card img {
      max-width: 100%;
      border-radius: 8px;
      margin-top: 10px;
    }
    .comment {
      background: #f9f9f9;
      padding: 5px;
      margin-top: 5px;
      border-radius: 5px;
    }
    #whatsappBtn a {
      background: green;
      color: white;
      padding: 10px 20px;
      border-radius: 8px;
      text-decoration: none;
      display: inline-block;
    }
  </style>
</head>
<body>

  <div class="login-container" id="loginSection">
    <h2>تسجيل الدخول</h2>
    <label>اختر نوع الدخول:</label>
    <select id="loginType">
      <option value="client">عميل</option>
      <option value="admin">مدير</option>
    </select>

    <div id="nameField">
      <input type="text" id="username" placeholder="اكتب اسمك">
    </div>

    <div id="regionField" style="display: none;">
      <label>اختر المنطقة:</label>
      <select id="region">
        <option value="">اختر المنطقة</option>
        <option value="القفر">القفر</option>
        <option value="يريم">يريم</option>
        <option value="إب">إب</option>
        <option value="الرضمة">الرضمة</option>
      </select>
    </div>

    <div id="villageField" style="display: none;">
      <input type="text" id="village" placeholder="اسم القرية">
    </div>

    <div id="passwordField" style="display: none;">
      <input type="password" id="password" placeholder="كلمة السر">
    </div>

    <button onclick="login()">دخول</button>
  </div>

  <div class="app-container" id="appSection" style="display: none;">
    <h2>منصة الإعلانات</h2>

    <div id="adminControls" style="display: none;">
      <input type="text" id="servicePhone" placeholder="رقم خدمة العملاء (واتساب)">
      <button onclick="saveServiceNumber()">حفظ رقم خدمة العملاء</button>

      <h3>إضافة إعلان</h3>
      <input type="text" id="adTitle" placeholder="عنوان الإعلان">
      <textarea id="adDesc" placeholder="وصف الإعلان"></textarea>
      <select id="adType">
        <option>مستشفى</option>
        <option>عيادة</option>
        <option>بقالة</option>
        <option>بيع سيارة</option>
        <option>بيع حطب</option>
        <option>تهنئة عريس</option>
        <option>دعوة زفاف</option>
        <option>بيع عقارات</option>
      </select>
      <input type="text" id="adPhone" placeholder="رقم تواصل صاحب الإعلان">
      <label>مدة الإعلان:</label>
      <select id="adDuration">
        <option value="3">3 أيام</option>
        <option value="5">5 أيام</option>
        <option value="10">10 أيام</option>
      </select>
      <input type="file" id="adImage" multiple accept="image/*">
      <button onclick="addAd()">نشر الإعلان</button>

      <h4>عدد المشتركين: <span id="subscriberCount">0</span></h4>
    </div>

    <div id="adsContainer"></div>

    <div id="whatsappBtn" style="text-align: center; margin-top: 20px; display: none;">
      <a id="whatsappLink" href="#" target="_blank">📞 تواصل مع خدمة العملاء عبر واتساب</a>
    </div>
  </div>

  <script>
    let isAdmin = false;
    let serviceNumber = "";
    let ads = [];
    let subscribers = 0;

    document.getElementById('loginType').addEventListener('change', function () {
      const type = this.value;
      document.getElementById('passwordField').style.display = type === 'admin' ? 'block' : 'none';
      document.getElementById('regionField').style.display = type === 'client' ? 'block' : 'none';
    });

    document.getElementById('region').addEventListener('change', function () {
      document.getElementById('villageField').style.display = this.value !== '' ? 'block' : 'none';
    });

    function login() {
      const type = document.getElementById('loginType').value;
      const username = document.getElementById('username').value;
      const password = document.getElementById('password').value;
      const region = document.getElementById('region').value;
      const village = document.getElementById('village').value;

      if (type === 'admin') {
        if (password === '001090Mh') {
          isAdmin = true;
          startApp();
        } else {
          alert('كلمة السر غير صحيحة!');
        }
      } else {
        if (username.trim() === '' || region.trim() === '' || village.trim() === '') {
          alert('يرجى تعبئة جميع الحقول للعميل');
        } else {
          subscribers++;
          isAdmin = false;
          startApp();
        }
      }
    }

    function saveServiceNumber() {
      const phoneInput = document.getElementById("servicePhone");
      if (phoneInput && phoneInput.value.trim() !== "") {
        serviceNumber = phoneInput.value.trim();
        alert("تم حفظ رقم خدمة العملاء");
      }
    }

    function startApp() {
      document.getElementById('loginSection').style.display = 'none';
      document.getElementById('appSection').style.display = 'block';

      if (isAdmin) {
        document.getElementById('adminControls').style.display = 'block';
        document.getElementById('subscriberCount').textContent = subscribers;
      } else {
        if (serviceNumber !== "") {
          document.getElementById('whatsappBtn').style.display = 'block';
          document.getElementById('whatsappLink').href = `https://wa.me/${serviceNumber}`;
        }
      }

      loadAds();
    }

    function addAd() {
      const title = document.getElementById('adTitle').value;
      const desc = document.getElementById('adDesc').value;
      const type = document.getElementById('adType').value;
      const phone = document.getElementById('adPhone').value;
      const duration = parseInt(document.getElementById('adDuration').value);
      const files = document.getElementById('adImage').files;
      const images = [];

      if (files.length === 0) {
        alert('يرجى اختيار صورة واحدة على الأقل');
        return;
      }

      let loaded = 0;
      for (let i = 0; i < files.length; i++) {
        const fr = new FileReader();
        fr.onload = function (e) {
          images.push(e.target.result);
          loaded++;
          if (loaded === files.length) {
            const now = new Date();
            const endDate = new Date(now.getTime() + duration * 24 * 60 * 60 * 1000);
            const ad = {
              title, desc, type, phone, images, comments: [], views: 0, expire: endDate.getTime()
            };
            ads.push(ad);
            renderAds();
          }
        };
        fr.readAsDataURL(files[i]);
      }
    }

    function renderAds() {
      const container = document.getElementById('adsContainer');
      container.innerHTML = '';
      const now = new Date().getTime();

      ads.forEach((ad, index) => {
        if (now > ad.expire) return;

        ad.views++;
        const card = document.createElement('div');
        card.className = 'ad-card';
        card.innerHTML = `
          <h3>${ad.title}</h3>
          <p>نوع الإعلان: <strong>${ad.type}</strong></p>
          <p>${ad.desc}</p>
          <p>📞 رقم التواصل: <a href="https://wa.me/${ad.phone}" target="_blank">${ad.phone}</a></p>
          <p>👁️ عدد المشاهدات: ${ad.views}</p>
          ${ad.images.map(img => `<img src="${img}">`).join('')}
          <div><strong>التعليقات:</strong></div>
          <div id="comments-${index}">
            ${ad.comments.map(c => `<div class='comment'>${c}</div>`).join('')}
          </div>
          ${!isAdmin ? `
            <input type='text' placeholder='اكتب تعليقك' id='commentInput-${index}'>
            <button onclick='addComment(${index})'>إرسال</button>
          ` : ''}
        `;
        container.appendChild(card);
      });
    }

    function addComment(index) {
      const input = document.getElementById(`commentInput-${index}`);
      if (input.value.trim() !== '') {
        ads[index].comments.push(input.value.trim());
        renderAds();
      }
    }

    function loadAds() {
      renderAds();
    }
  </script>

</body>
</html>
