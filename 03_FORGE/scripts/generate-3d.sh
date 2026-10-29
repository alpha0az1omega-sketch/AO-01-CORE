#!/bin/bash
mkdir -p 04_MULTIMEDIA/3d 04_MULTIMEDIA/evolution
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
LEU_FILE=$(ls 04_MULTIMEDIA/leu/*.leu | head -n 1)
LEU_HASH=$(shasum -a 256 "$LEU_FILE" | cut -d ' ' -f 1)
if [ -f "04_MULTIMEDIA/3d/portal.html" ]; then cp "04_MULTIMEDIA/3d/portal.html" "04_MULTIMEDIA/evolution/portal_v_${TIMESTAMP}.html"; fi

cat << HTML > 04_MULTIMEDIA/3d/portal.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>AO-01-CORE | SOVEREIGN UNIVERSE</title>
    <style>
        body { margin: 0; overflow: hidden; background-color: #050510; color: #fff; font-family: 'Courier New', monospace; }
        
        #hud { position: absolute; top: 20px; right: 30px; z-index: 100; text-align: right; pointer-events: none; text-shadow: 0 0 10px rgba(88,166,255,0.8); }
        .stat { margin: 5px 0; font-size: 0.9em; color: #58a6ff; font-weight: bold; }
        .value { color: #fff; }
        .entropy { color: #ff7b72; }

        #chat-container { position: absolute; bottom: 30px; left: 50%; transform: translateX(-50%); width: 80%; max-width: 800px; z-index: 100; display: flex; flex-direction: column; gap: 10px; }
        #chat-output { color: #7fc839; font-size: 1em; text-shadow: 0 0 5px #7fc839; min-height: 50px; display: flex; flex-direction: column; justify-content: flex-end; max-height: 200px; overflow-y: hidden; }
        .msg-user { color: #d2a8ff; text-align: right; text-shadow: 0 0 5px #d2a8ff; margin: 2px 0; }
        .msg-ai { color: #7fc839; text-align: left; text-shadow: 0 0 5px #7fc839; margin: 2px 0; }
        
        #chat-input-wrapper { display: flex; border-bottom: 2px solid #30363d; padding-bottom: 5px; transition: border-color 0.3s; }
        #chat-input-wrapper:focus-within { border-color: #58a6ff; box-shadow: 0 10px 10px -10px #58a6ff; }
        #chat-input { background: transparent; border: none; color: #fff; font-family: inherit; font-size: 1.2em; width: 100%; outline: none; padding: 5px; }
        #chat-input::placeholder { color: #555; }
        
        .brand { position: absolute; top: 20px; left: 30px; font-size: 1.2em; font-weight: bold; color: #58a6ff; letter-spacing: 2px; text-shadow: 0 0 10px #58a6ff; z-index: 100; }
        .brand span { color: #7fc839; }
        .controls { position: absolute; top: 20px; left: 50%; transform: translateX(-50%); z-index: 100; display: flex; gap: 15px; }
        .btn { background: transparent; border: 1px solid #30363d; color: #c9d1d9; padding: 5px 15px; cursor: pointer; font-family: inherit; font-size: 0.8em; border-radius: 4px; transition: 0.3s; }
        .btn:hover { border-color: #58a6ff; color: #58a6ff; }
        .btn.active { background: rgba(127,200,57,0.2); border-color: #7fc839; color: #7fc839; }
        
        #copyright { position: absolute; bottom: 5px; left: 50%; transform: translateX(-50%); font-size: 0.7em; color: #333; z-index: 100; letter-spacing: 2px; }
    </style>
</head>
<body>
    <div class="brand">ALPHA_0AZ1OMEGA <span>// SOVEREIGN</span></div>

    <div class="controls">
        <button class="btn" id="toggle-audio">AUDIO: OFF</button>
        <button class="btn" id="evolve-agent">EVOLVE AGENT</button>
    </div>

    <div id="hud">
        <div class="stat">LOCAL: <span class="value" id="local-time"></span></div>
        <div class="stat">UTC: <span class="value" id="utc-time"></span></div>
        <div class="stat">ENTROPY: <span class="entropy" id="entropy"></span></div>
        <div class="stat">FORMAT: <span class="value" id="format-display">i.svg</span></div>
        <div class="stat">SHA-256: <span class="value">${LEU_HASH:0:12}...</span></div>
    </div>

    <div id="chat-container">
        <div id="chat-output">
            <div class="msg-ai">AI: Initialization complete. I am ready. Ask me about the universe, I-Formats, or mathematics.</div>
        </div>
        <div id="chat-input-wrapper">
            <input type="text" id="chat-input" placeholder="Type your command here..." autocomplete="off">
        </div>
    </div>

    <div id="copyright">© 2026 ALPHA_0AZ1OMEGA | NUMERICAL SOVEREIGNTY</div>

    <script type="importmap">
        { "imports": { "three": "https://unpkg.com/three@0.160.0/build/three.module.js", "three/addons/": "https://unpkg.com/three@0.160.0/examples/jsm/" } }
    </script>

    <script type="module">
        import * as THREE from 'three';
        import { OrbitControls } from 'three/addons/controls/OrbitControls.js';
        import { EffectComposer } from 'three/addons/postprocessing/EffectComposer.js';
        import { RenderPass } from 'three/addons/postprocessing/RenderPass.js';
        import { UnrealBloomPass } from 'three/addons/postprocessing/UnrealBloomPass.js';

        // --- AUDIO (432 Hz) ---
        let audioCtx, oscillator, isAudioPlaying = false;
        const audioBtn = document.getElementById('toggle-audio');
        audioBtn.addEventListener('click', () => {
            if (!audioCtx) audioCtx = new (window.AudioContext || window.webkitAudioContext)();
            if (isAudioPlaying) {
                oscillator.stop(); audioBtn.textContent = "AUDIO: OFF"; audioBtn.classList.remove('active');
            } else {
                oscillator = audioCtx.createOscillator();
                const gainNode = audioCtx.createGain();
                oscillator.type = 'sine';
                oscillator.frequency.setValueAtTime(432, audioCtx.currentTime);
                gainNode.gain.setValueAtTime(0.05, audioCtx.currentTime);
                oscillator.connect(gainNode); gainNode.connect(audioCtx.destination); oscillator.start();
                audioBtn.textContent = "AUDIO: ON (432Hz)"; audioBtn.classList.add('active');
            }
            isAudioPlaying = !isAudioPlaying;
        });

        // --- SCENE ---
        const scene = new THREE.Scene();
        const camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 0.1, 1000);
        camera.position.set(0, 5, 30);

        const renderer = new THREE.WebGLRenderer({ antialias: true, alpha: true });
        renderer.setSize(window.innerWidth, window.innerHeight);
        renderer.setPixelRatio(window.devicePixelRatio);
        document.body.appendChild(renderer.domElement);

        // LIGHTS
        const ambientLight = new THREE.AmbientLight(0xffffff, 0.6);
        scene.add(ambientLight);
        const pointLight = new THREE.PointLight(0xffffff, 2, 100);
        pointLight.position.set(10, 10, 10);
        scene.add(pointLight);

        // NEBULA (No heavy texture, just colorful points)
        const bgGeo = new THREE.BufferGeometry();
        const bgCount = 20000;
        const bgPos = new Float32Array(bgCount * 3);
        const bgCol = new Float32Array(bgCount * 3);
        const c = new THREE.Color();
        for(let i=0; i<bgCount; i++) {
            const r = 30 + Math.random() * 100;
            const theta = Math.random() * Math.PI * 2;
            const phi = Math.acos((Math.random() * 2) - 1);
            bgPos[i*3] = r * Math.sin(phi) * Math.cos(theta);
            bgPos[i*3+1] = r * Math.sin(phi) * Math.sin(theta);
            bgPos[i*3+2] = r * Math.cos(phi);
            c.setHSL(Math.random() * 0.3 + 0.5, 0.9, 0.5); 
            bgCol[i*3] = c.r; bgCol[i*3+1] = c.g; bgCol[i*3+2] = c.b;
        }
        bgGeo.setAttribute('position', new THREE.BufferAttribute(bgPos, 3));
        bgGeo.setAttribute('color', new THREE.BufferAttribute(bgCol, 3));
        const bgMat = new THREE.PointsMaterial({ size: 0.8, vertexColors: true, transparent: true, opacity: 0.8, blending: THREE.AdditiveBlending, depthWrite: false });
        const bgNebula = new THREE.Points(bgGeo, bgMat);
        scene.add(bgNebula);

        // DIAMOND CORE
        const knotGeo = new THREE.TorusKnotGeometry(6, 1.2, 200, 32, 2, 3);
        const knotMat = new THREE.MeshStandardMaterial({ 
            color: 0xffffff, 
            metalness: 0.9, 
            roughness: 0.1, 
            emissive: 0x1f6feb, 
            emissiveIntensity: 0.5 
        });
        const torusKnot = new THREE.Mesh(knotGeo, knotMat);
        scene.add(torusKnot);

        // MOONS
        const moons = [];
        const moonColors = [0xff7b72, 0xd2a8ff, 0x7fc839];
        for (let i = 0; i < 3; i++) {
            const mGeo = new THREE.SphereGeometry(1.0, 32, 32);
            const mMat = new THREE.MeshStandardMaterial({ color: moonColors[i], emissive: moonColors[i], emissiveIntensity: 0.8 });
            const moon = new THREE.Mesh(mGeo, mMat);
            moon.userData = { index: i, radius: 14 + i * 3, speed: 0.5 + i * 0.2 };
            scene.add(moon);
            moons.push(moon);
        }

        // FIBERS
        const fiberGeo = new THREE.BufferGeometry();
        const fiberPos = new Float32Array(3 * 2 * 3); 
        fiberGeo.setAttribute('position', new THREE.BufferAttribute(fiberPos, 3));
        const fiberMat = new THREE.LineBasicMaterial({ color: 0xffffff, transparent: true, opacity: 0.3 });
        const fibers = new THREE.LineSegments(fiberGeo, fiberMat);
        scene.add(fibers);

        const composer = new EffectComposer(renderer);
        composer.addPass(new RenderPass(scene, camera));
        composer.addPass(new UnrealBloomPass(new THREE.Vector2(window.innerWidth, window.innerHeight), 1.2, 0.4, 0.85));

        const controls = new OrbitControls(camera, renderer.domElement);
        controls.enableDamping = true;
        controls.autoRotate = true;
        controls.autoRotateSpeed = 0.2;

        // --- DATA & CHAT ---
        const localTimeEl = document.getElementById('local-time');
        const utcTimeEl = document.getElementById('utc-time');
        const entropyEl = document.getElementById('entropy');
        const formatDisplay = document.getElementById('format-display');
        const chatOutput = document.getElementById('chat-output');
        const chatInput = document.getElementById('chat-input');
        const symbols = ['i.svg', 'i.video', 'i.nft', 'i.exegylyphe', 'i.script', 'E=mc2', 'i.png', 'i.coin', 'bitcoin', 'suno', 'opensea', 'blockchain', 'integral', 'i.wasm', '0x7F'];

        setInterval(() => {
            const now = new Date();
            localTimeEl.textContent = now.toLocaleTimeString();
            utcTimeEl.textContent = now.toISOString().split('T')[1].slice(0,8);
            entropyEl.textContent = Math.random().toString(36).substring(2, 10).toUpperCase();
            formatDisplay.textContent = symbols[Math.floor(Math.random() * symbols.length)];
        }, 1000);

        chatInput.addEventListener('keypress', function (e) {
            if (e.key === 'Enter') {
                const text = chatInput.value.trim();
                if (text) {
                    const userDiv = document.createElement('div');
                    userDiv.className = 'msg-user';
                    userDiv.textContent = "YOU: " + text;
                    chatOutput.appendChild(userDiv);
                    chatInput.value = '';
                    chatOutput.scrollTop = chatOutput.scrollHeight;

                    setTimeout(() => {
                        const aiDiv = document.createElement('div');
                        aiDiv.className = 'msg-ai';
                        let response = "Command received. Analyzing...";
                        if (text.toLowerCase().includes('hello') || text.toLowerCase().includes('hi')) {
                            response = "Hello Creator. The universe is stable. What shall we explore?";
                        } else if (text.toLowerCase().includes('format') || text.toLowerCase().includes('nft')) {
                            response = "I-Formats (i.svg, i.nft, i.video) are undergoing cryptographic validation. Blockchain synchronized.";
                        } else if (text.toLowerCase().includes('math')) {
                            response = "The core is calculating Lissajous curves and fractals in real-time.";
                        } else {
                            response = "Request logged. AI guide is mutating to integrate this new data.";
                        }
                        aiDiv.textContent = "AI: " + response;
                        chatOutput.appendChild(aiDiv);
                        chatOutput.scrollTop = chatOutput.scrollHeight;
                    }, 800);
                }
            }
        });

        let agentEvolution = 0;
        document.getElementById('evolve-agent').addEventListener('click', () => {
            agentEvolution++;
            torusKnot.material.emissive.setHSL((agentEvolution * 0.1) % 1, 1, 0.5);
            const aiDiv = document.createElement('div');
            aiDiv.className = 'msg-ai';
            aiDiv.textContent = `AI: Agent Evolved. Epoch ${agentEvolution}. New capabilities unlocked.`;
            chatOutput.appendChild(aiDiv);
            chatOutput.scrollTop = chatOutput.scrollHeight;
        });

        const clock = new THREE.Clock();

        function animate() {
            requestAnimationFrame(animate);
            const time = clock.getElapsedTime();

            bgNebula.rotation.y = time * 0.01;
            bgNebula.rotation.x = time * 0.005;

            torusKnot.rotation.x = time * 0.1;
            torusKnot.rotation.y = time * 0.2;

            const positions = fibers.geometry.attributes.position.array;
            moons.forEach((moon, i) => {
                const t = time * moon.userData.speed + (i * Math.PI * 2 / 3);
                moon.position.x = Math.cos(t) * moon.userData.radius;
                moon.position.y = Math.sin(t * 2) * 5;
                moon.position.z = Math.sin(t) * moon.userData.radius;

                positions[i*6] = 0; positions[i*6+1] = 0; positions[i*6+2] = 0;
                positions[i*6+3] = moon.position.x;
                positions[i*6+4] = moon.position.y;
                positions[i*6+5] = moon.position.z;
            });
            fibers.geometry.attributes.position.needsUpdate = true;

            controls.update();
            composer.render();
        }

        animate();

        window.addEventListener('resize', () => {
            camera.aspect = window.innerWidth / window.innerHeight;
            camera.updateProjectionMatrix();
            renderer.setSize(window.innerWidth, window.innerHeight);
            composer.setSize(window.innerWidth, window.innerHeight);
        });
    </script>
</body>
</html>
HTML
echo "[+] Sovereign Universe Portal generated. 3D Fixed."
