
uniform float time;
uniform sampler2D noise_tex;
uniform sampler2D test_tex;

varying vec4 vertColor;
varying vec4 vertTexCoord;

const float COLORFULNESS = 0.5;
const float TIME_SCALE = 0.05;

const float QUART_PI = 0.785398163397;
const float HALF_PI = 1.57079632679;
const float PI = 3.14159265359;
const float TWO_PI = 6.28318530718;

vec2 uv_map(float radius, float theta) {
	/* float circle_to_square_mapping = 1.0/(cos(mod(theta, HALF_PI)-QUART_PI));
	return 0.5 * (radius * circle_to_square_mapping * vec2(cos(theta-QUART_PI),sin(theta-QUART_PI)) + 1.0); */
	return 0.5 * (radius * vec2(cos(theta-QUART_PI),sin(theta-QUART_PI)) + 1.0);
}

void main() {
	//vec2 uv;

	float lat = vertTexCoord.y;
	float theta = TWO_PI * vertTexCoord.x;

	/* if(lat <= 0.5) {
		uv = uv_map(2.0*lat, theta);
	} else {
		if(mod(theta,PI) <= HALF_PI) {
			theta = 0.75*TWO_PI - theta;
		} else {
			theta = 1.25*TWO_PI - theta;
		}
		uv = uv_map(2.0*(1.0-lat), theta);
	} */
	
	vec3 color;

	if(lat >= 0.5) {
		vec2 uv = uv_map(2.0*(1.0-lat), theta);
		float noise = texture2D(noise_tex, uv).r + TIME_SCALE*time;
		//vec3 color = texture2D(noise_tex, fract(vec2(noise))).r * vertColor.rgb;
		color = vec3(texture2D(noise_tex, fract(vec2(noise))).r,
						texture2D(noise_tex, fract(vec2(noise)+vec2(COLORFULNESS,0.0))).r,
						texture2D(noise_tex, fract(vec2(noise)+vec2(0.0,COLORFULNESS))).r);
		
		//gl_FragColor = texture2D(test_tex, uv);
		//if(vertTexCoord.y > 0.99) gl_FragColor = vec4(1.0,0.0,0.0,1.0);
	} else {
		color = vec3(0.7);
	}
	gl_FragColor = vec4(color, 1.0);
}

