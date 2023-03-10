// vertex shader
#define GLSLIFY 1
uniform sampler2D positions;
uniform float pointSize;

void main() {
    vec3 pos = texture2D(positions, position.xy).xyz;
    gl_Position = projectionMatrix * modelViewMatrix * vec4( pos, 1.0 );
    gl_PointSize = step(1.0 - (1.0/64.0), position.x) * pointSize;
}

// fragment shader
#define GLSLIFY 1
void main() {
    gl_FragColor = vec4(1.0, 1.0, 1.0, 1.0);
}

// vertex shader
#define GLSLIFY 1
varying vec2 vUv;

void main() {
  vUv = uv;
  gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
}

// fragment shader
#define GLSLIFY 1
precision mediump float;
uniform float attractor;
uniform sampler2D positions;
varying vec2 vUv;

vec3 lorezAttractor(vec3 pos) {

    // Lorenz Attractor parameters
    float a = 10.0;
    float b = 28.0;
    float c = 2.6666666667;

    // Timestep
    float dt = 0.004;
    float x = pos.x;
    float y = pos.y;
    float z = pos.z;
    float dx, dy, dz;

    dx = dt * (a * (y - x));
    dy = dt * (x * (b - z) - y);
    dz = dt * (x * y - c * z);
    return vec3(dx, dy, dz);
}

vec3 lorezMod2Attractor(vec3 pos) {
    // Lorenz Mod2 Attractor parameters
    float a = 0.9;
    float b = 5.0;
    float c = 9.9;
    float d = 1.0;

    // Timestep
    float dt = 0.0005;
    float x = pos.x;
    float y = pos.y;
    float z = pos.z;
    float dx, dy, dz;

    dx = (-a*x, y*y - z*z,  a *c) * dt;
    dy = (x*(y-b*z)+d) * dt;
    dz = (-z + x*(b*y + z)) * dt;
    return vec3(dx, dy, dz);
}

vec3 thomasAttractor(vec3 pos) {
    float b = 0.19;
    // Timestep
    float dt = 0.01;
    float x = pos.x;
    float y = pos.y;
    float z = pos.z;
    float dx, dy, dz;

    dx = (-b*x + sin(y)) * dt;
    dy = (-b*y + sin(z)) * dt;
    dz = (-b*z + sin(x)) * dt;
    return vec3(dx, dy, dz);
}

vec3 dequanAttractor(vec3 pos) {
    float a = 40.0;
    float b = 1.833;
    float c = 0.16;
    float d = 0.65;
    float e = 55.0;
    float f = 20.0;

    // Timestep
    float dt = 0.0005;
    float x = pos.x;
    float y = pos.y;
    float z = pos.z;
    float dx, dy, dz;

    dx = ( a*(y-x) + c*x*z) * dt;
    dy = (e*x + f*y - x*z) * dt;
    dz = (b*z + x*y - d*x*x) * dt;
    return vec3(dx, dy, dz);
}

vec3 dradasAttractor(vec3 pos) {
    float a = 3.0;
    float b = 2.7;
    float c = 1.7;
    float d = 2.0;
    float e = 9.0;

    // Timestep
    float dt = 0.0020;
    float x = pos.x;
    float y = pos.y;
    float z = pos.z;
    float dx, dy, dz;

    dx = (y- a*x +b*y*z) * dt;
    dy = (c*y -x*z +z) * dt;
    dz = (d*x*y - e*z) * dt;

    return vec3(dx, dy, dz);
}

vec3 arneodoAttractor(vec3 pos) {
    float a = -5.5;
    float b = 3.5;
    float d = -1.0;

    // Timestep
    float dt = 0.0020;
    float x = pos.x;
    float y = pos.y;
    float z = pos.z;
    float dx, dy, dz;

    dx = y * dt;
    dy = z * dt;
    dz = (-a*x -b*y -z + (d* (pow(x, 3.0)))) * dt;

    return vec3(dx, dy, dz);
}

vec3 aizawaAttractor(vec3 pos) {
    float a = 0.95;
    float b = 0.7;
    float c = 0.6;
    float d = 3.5;
    float e = 0.25;
    float f = 0.1;

    // Timestep
    float dt = 0.003;
    float x = pos.x;
    float y = pos.y;
    float z = pos.z;
    float dx, dy, dz;

    dx = ((z-b) * x - d*y) * dt;
    dy = (d * x + (z-b) * y) * dt;
    dz = (c + a*z - ((z*z*z) / 3.0) - (x*x) + f * z * (x*x*x)) * dt;
    return vec3(dx, dy, dz);
}

void main() {

    vec3 pos = texture2D(positions, vUv).rgb;
    vec3 delta;

    if(attractor == 0.0) {
        delta = lorezAttractor(pos);
    }
    if(attractor == 1.0) {
        delta = lorezMod2Attractor(pos);
    }
    if(attractor == 2.0) {
        delta = thomasAttractor(pos);
    }
    if(attractor == 3.0) {
        delta = dequanAttractor(pos);
    }
    if(attractor == 4.0) {
        delta = dradasAttractor(pos);
    }
    if(attractor == 5.0) {
        delta = arneodoAttractor(pos);
    }
    if(attractor == 6.0) {
        delta = aizawaAttractor(pos);
    }

    pos.x = delta.x;
    pos.y = delta.y;
    pos.z = delta.z;

    // pos.x = cos(pos.y) / 100.0
    // pos.y = tan(pos.x) / 100.0
    gl_FragColor = vec4(pos,1.0);
}


// vertex shader
uniform sampler2D uPositions;
uniform float uTime;

void main() {
    vec3 pos = texture2D(uPositions, position.xy).xyz;

    vec4 modelPosition = modelMatrix * vec4(pos, 1.0);
    vec4 viewPosition = viewMatrix * modelPosition;
    vec4 projectedPosition = projectionMatrix * viewPosition;

    gl_Position = projectedPosition;

    gl_PointSize = 3.0;
    // Size attenuation;
    gl_PointSize *= step(1.0 - (1.0/64.0), position.x) + 0.5;
}

// fragment shader
void main() {
    vec3 color = vec3(0.67, 0.56, 0.86);
    gl_FragColor = vec4(color, 1.0);
}


// simulation vertex shader
varying vec2 vUv;

void main() {
    vUv = uv;

    vec4 modelPosition = modelMatrix * vec4(position, 1.0);
    vec4 viewPosition = viewMatrix * modelPosition;
    vec4 projectedPosition = projectionMatrix * viewPosition;

    gl_Position = projectedPosition;
}


// simulation fragment shader
uniform sampler2D positions;
uniform float uTime;
uniform float uFrequency;

varying vec2 vUv;

//
// Description : Array and textureless GLSL 2D/3D/4D simplex
//               noise functions.
//      Author : Ian McEwan, Ashima Arts.
//  Maintainer : ijm
//     Lastmod : 20110822 (ijm)
//     License : Copyright (C) 2011 Ashima Arts. All rights reserved.
//               Distributed under the MIT License. See LICENSE file.
//               https://github.com/ashima/webgl-noise
//

vec3 mod289(vec3 x) {
    return x - floor(x * (1.0 / 289.0)) * 289.0;
}

vec4 mod289(vec4 x) {
    return x - floor(x * (1.0 / 289.0)) * 289.0;
}

vec4 permute(vec4 x) {
    return mod289(((x*34.0)+1.0)*x);
}

vec4 taylorInvSqrt(vec4 r)
{
    return 1.79284291400159 - 0.85373472095314 * r;
}

float snoise(vec3 v)
{
    const vec2  C = vec2(1.0/6.0, 1.0/3.0) ;
    const vec4  D = vec4(0.0, 0.5, 1.0, 2.0);

    // First corner
    vec3 i  = floor(v + dot(v, C.yyy) );
    vec3 x0 =   v - i + dot(i, C.xxx) ;

    // Other corners
    vec3 g = step(x0.yzx, x0.xyz);
    vec3 l = 1.0 - g;
    vec3 i1 = min( g.xyz, l.zxy );
    vec3 i2 = max( g.xyz, l.zxy );

    //   x0 = x0 - 0.0 + 0.0 * C.xxx;
    //   x1 = x0 - i1  + 1.0 * C.xxx;
    //   x2 = x0 - i2  + 2.0 * C.xxx;
    //   x3 = x0 - 1.0 + 3.0 * C.xxx;
    vec3 x1 = x0 - i1 + C.xxx;
    vec3 x2 = x0 - i2 + C.yyy; // 2.0*C.x = 1/3 = C.y
    vec3 x3 = x0 - D.yyy;      // -1.0+3.0*C.x = -0.5 = -D.y

    // Permutations
    i = mod289(i);
    vec4 p = permute( permute( permute(
    i.z + vec4(0.0, i1.z, i2.z, 1.0 ))
    + i.y + vec4(0.0, i1.y, i2.y, 1.0 ))
    + i.x + vec4(0.0, i1.x, i2.x, 1.0 ));

    // Gradients: 7x7 points over a square, mapped onto an octahedron.
    // The ring size 17*17 = 289 is close to a multiple of 49 (49*6 = 294)
    float n_ = 0.142857142857; // 1.0/7.0
    vec3  ns = n_ * D.wyz - D.xzx;

    vec4 j = p - 49.0 * floor(p * ns.z * ns.z);  //  mod(p,7*7)

    vec4 x_ = floor(j * ns.z);
    vec4 y_ = floor(j - 7.0 * x_ );    // mod(j,N)

    vec4 x = x_ *ns.x + ns.yyyy;
    vec4 y = y_ *ns.x + ns.yyyy;
    vec4 h = 1.0 - abs(x) - abs(y);

    vec4 b0 = vec4( x.xy, y.xy );
    vec4 b1 = vec4( x.zw, y.zw );

    //vec4 s0 = vec4(lessThan(b0,0.0))*2.0 - 1.0;
    //vec4 s1 = vec4(lessThan(b1,0.0))*2.0 - 1.0;
    vec4 s0 = floor(b0)*2.0 + 1.0;
    vec4 s1 = floor(b1)*2.0 + 1.0;
    vec4 sh = -step(h, vec4(0.0));

    vec4 a0 = b0.xzyw + s0.xzyw*sh.xxyy ;
    vec4 a1 = b1.xzyw + s1.xzyw*sh.zzww ;

    vec3 p0 = vec3(a0.xy,h.x);
    vec3 p1 = vec3(a0.zw,h.y);
    vec3 p2 = vec3(a1.xy,h.z);
    vec3 p3 = vec3(a1.zw,h.w);

    //Normalise gradients
    vec4 norm = taylorInvSqrt(vec4(dot(p0,p0), dot(p1,p1), dot(p2, p2), dot(p3,p3)));
    p0 *= norm.x;
    p1 *= norm.y;
    p2 *= norm.z;
    p3 *= norm.w;

    // Mix final noise value
    vec4 m = max(0.6 - vec4(dot(x0,x0), dot(x1,x1), dot(x2,x2), dot(x3,x3)), 0.0);
    m = m * m;
    return 42.0 * dot( m*m, vec4( dot(p0,x0), dot(p1,x1),
    dot(p2,x2), dot(p3,x3) ) );
}


vec3 snoiseVec3( vec3 x ){

    float s  = snoise(vec3( x ));
    float s1 = snoise(vec3( x.y - 19.1 , x.z + 33.4 , x.x + 47.2 ));
    float s2 = snoise(vec3( x.z + 74.2 , x.x - 124.5 , x.y + 99.4 ));
    vec3 c = vec3( s , s1 , s2 );
    return c;

}



vec3 curlNoise( vec3 p ){

    const float e = .1;
    vec3 dx = vec3( e   , 0.0 , 0.0 );
    vec3 dy = vec3( 0.0 , e   , 0.0 );
    vec3 dz = vec3( 0.0 , 0.0 , e   );

    vec3 p_x0 = snoiseVec3( p - dx );
    vec3 p_x1 = snoiseVec3( p + dx );
    vec3 p_y0 = snoiseVec3( p - dy );
    vec3 p_y1 = snoiseVec3( p + dy );
    vec3 p_z0 = snoiseVec3( p - dz );
    vec3 p_z1 = snoiseVec3( p + dz );

    float x = p_y1.z - p_y0.z - p_z1.y + p_z0.y;
    float y = p_z1.x - p_z0.x - p_x1.z + p_x0.z;
    float z = p_x1.y - p_x0.y - p_y1.x + p_y0.x;

    const float divisor = 1.0 / ( 2.0 * e );
    return normalize( vec3( x , y , z ) * divisor );

}


void main() {
    vec3 pos = texture2D(positions, vUv).rgb;
    vec3 curlPos = texture2D(positions, vUv).rgb;

    pos = curlNoise(pos * uFrequency + uTime * 0.1);
    curlPos = curlNoise(curlPos * uFrequency + uTime * 0.1);
    curlPos += curlNoise(curlPos * uFrequency * 2.0) * 0.5;

    gl_FragColor = vec4(mix(pos, curlPos, sin(uTime)), 1.0);
}
