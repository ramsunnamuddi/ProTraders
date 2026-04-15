<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Login</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      background: linear-gradient(120deg, #2980b9, #6dd5fa);
      height: 100vh;
      display: flex;
      justify-content: center;
      align-items: center;
    }

    .login-container {
      background-color: white;
      padding: 2rem;
      border-radius: 12px;
      box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);
      width: 100%;
      max-width: 400px;
      z-index: 1;
    }

    h2 {
      text-align: center;
      margin-bottom: 1.5rem;
    }

    .form-group {
      margin-bottom: 1rem;
    }

    .form-group label {
      display: block;
      margin-bottom: 0.5rem;
    }

    .form-group input {
      width: 100%;
      padding: 0.75rem;
      border: 1px solid #ccc;
      border-radius: 8px;
    }

    .login-btn {
      width: 100%;
      padding: 0.75rem;
      background-color: #2980b9;
      border: none;
      color: white;
      border-radius: 8px;
      font-size: 1rem;
      cursor: pointer;
    }

    .login-btn:hover {
      background-color: #2573a6;
    }

    #error-msg {
      text-align: center;
      color: red;
      margin-top: 1rem;
      display: none;
    }

    /* 🔄 Loading overlay style */
    .overlay {
      position: fixed;
      top: 0;
      left: 0;
      width: 100vw;
      height: 100vh;
      background: rgba(0, 0, 0, 0.6);
      display: none;
      justify-content: center;
      align-items: center;
      z-index: 999;
    }

    .overlay span {
      color: white;
      font-size: 1.5rem;
      background-color: #000000a6;
      padding: 1rem 2rem;
      border-radius: 10px;
    }
  </style>
</head>
<body>

  <!-- Login Form -->
  <div class="login-container">
    <h2>Login</h2>
    <form id="loginForm">
      <div class="form-group">
        <label for="username">Username</label>
        <input type="text" id="username" name="username" required />
      </div>
      <div class="form-group">
        <label for="password">Password</label>
        <input type="password" id="password" name="password" required />
      </div>
      <button type="submit" class="login-btn">Login</button>
      <div id="error-msg">Invalid credentials. Please try again.</div>
    </form>
	<form action="admdashboard" method="post" name="login">
		<input type="hidden" value="" name="sid">			 
		<input type="hidden" value="" name="pid">
	</form>
  </div>

  <!-- 🔄 Full-screen loading overlay -->
  <div class="overlay" id="overlay">
    <span>Logging in...</span>
  </div>

  <script>
    document.getElementById('loginForm').addEventListener('submit', function (e) {
      e.preventDefault();

      const username = document.getElementById('username').value;
      const password = document.getElementById('password').value;
      const browserInfo = navigator.userAgent;
      const overlay = document.getElementById('overlay');
      const errorMsg = document.getElementById('error-msg');

      overlay.style.display = 'flex';
      errorMsg.style.display = 'none';
	  try{
		fetch('https://api.ipify.org?format=json')
	        .then(res => res.json())
	        .then(data => {
	          const ipAddress = data.ip;

	          return fetch('admin/dt/admlogin', {
	            method: 'POST',
	            headers: {
	              'Content-Type': 'application/json'
	            },
	            body: JSON.stringify({
	              username: username,
	              password: password,
	              ipAddress: ipAddress,
	              browserInfo: browserInfo
	            })
	          });
	        })
	        .then(res => res.json())
	        .then(data => {
	          if (data.errCd === '0') {
				const form = document.forms['login'];
				form['sid'].value = data.sid;
				form['pid'].value = data.pid;
				form.submit();
	          } else {
	            errorMsg.innerText = data.errMsg || 'Invalid credentials.';
	            errorMsg.style.display = 'block';
	          }
			  overlay.style.display = 'none';
	        })
	        .catch(error => {
	          overlay.style.display = 'none';
	          errorMsg.innerText = 'Something went wrong. Please try again.';
	          errorMsg.style.display = 'block';
	          console.error('Login error:', error);
	        });
	  }catch (error) {
       onsole.error(`Error loading ${section} data:`, error);
       showToast(`Error loading ${section} data`, 'danger');
      }finally {
        
      }
      
    });
  </script>
</body>
</html>
