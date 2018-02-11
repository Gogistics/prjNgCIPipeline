import { Component, AfterViewInit, Inject, NgZone } from '@angular/core';
import { DOCUMENT } from '@angular/common';

import * as WaveSurfer from 'wavesurfer';
import * as THREE from 'three';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent implements AfterViewInit {
  title = 'Let\'s Go with Angular on Dock';
  btnPlayOrPause = 'Play';
  wavesurfer: any = null;

  constructor(@Inject(DOCUMENT) private document: any,
    private zone: NgZone) {}

  playPause() {
    if (this.wavesurfer) this.wavesurfer.playPause();
    this.btnPlayOrPause = this.wavesurfer.isPlaying() ? 'Pause' : 'Play';
  }

  ngAfterViewInit() {
    const _this = this;

    this.zone.runOutsideAngular(() => {
      // init wavesurfer
      _this.wavesurfer = WaveSurfer.create({
        container: '#waveform',
        waveColor: 'red',
        progressColor: 'purple'
      });

      // load mp3
      _this.wavesurfer.load('/assets/tez_cadey_seve.mp3');
      _this.wavesurfer.on('finish', function () {
        _this.btnPlayOrPause = 'Play'
      });


      // three.js
      let scene = new THREE.Scene();
      let W = window.innerWidth;
      let H = window.innerHeight;

      let renderer = new THREE.WebGLRenderer();
      renderer.setClearColor(0xffffff);
      renderer.setSize(W, H);

      let camera = new THREE.PerspectiveCamera(60, W / H, 0.3, 10000);

      let planeGeometry = new THREE.PlaneGeometry(1000, 600, 200, 100);
      let planeMaterial = new THREE.MeshBasicMaterial({color: 0xff0000, wireframe: true});
      let plane = new THREE.Mesh(planeGeometry, planeMaterial);

      plane.rotation.x = -0.2 * Math.PI;

      plane.position.set(0, 0, 0);

      scene.add(plane);

      camera.position.set(0, 50, 100);
      camera.lookAt(scene.position);

      document.body.appendChild(renderer.domElement);

      (function drawFrame(ts: number){
        let center = new THREE.Vector2(0,0);
        window.requestAnimationFrame(drawFrame);
        let vLength = (plane as any).geometry.vertices.length;
        for (let i = 0; i < vLength; i++) {
          let v = (plane as any).geometry.vertices[i];
          let dist = new THREE.Vector2(v.x, v.y).sub(center);
          let size = 5.0;
          let magnitude = 4;
          v.z = Math.sin(dist.length()/-size + (ts/100)) * magnitude;
        }
        (plane as any).geometry.verticesNeedUpdate = true;
        renderer.render(scene, camera);
      }(1));
    });
  }
}
