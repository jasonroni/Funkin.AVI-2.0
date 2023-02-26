#define PI   3.14159265358979323846
#define TAU  6.28318530717958647693

//  TV-like adjustments
const float SAT = 1.0;      //  Saturation / "Color" (normally 1.0)
const float HUE = 0.0;      //  Hue / "Tint" (normally 0.0)
const float BRI = 1.0;      //  Brightness (normally 1.0)

//  Filter parameters
const int   N   = 15;       //  Filter Width
const int   M   = N/2;      //  Filter Middle
const float FC  = 0.25;     //  Frequency Cutoff
const float SCF = 0.25;     //  Subcarrier Frequency

//	Colorspace conversion matrix for YIQ-to-RGB
const mat3 YIQ2RGB = mat3(1.000, 1.000, 1.000,
                          0.956,-0.272,-1.106,
                          0.621,-0.647, 1.703);

//	TV-like adjustment matrix for Hue, Saturation, and Brightness
vec3 adjust(vec3 YIQ, float H, float S, float B) {
    mat3 M = mat3(  B,      0.0,      0.0,
                  0.0, S*cos(H),  -sin(H), 
                  0.0,   sin(H), S*cos(H) );
    return M * YIQ;
}

//	Hann windowing function
float hann(float n, float N) {
    return 0.5 * (1.0 - cos((TAU*n)/(N-1.0)));
}

//	Sinc function
float sinc(float x) {
    if (x == 0.0) return 1.0;
	return sin(PI*x) / (PI*x);
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
	vec2 size = iChannelResolution[0].xy;
	vec2 uv = fragCoord.xy / size;
    
    if (uv.y < 0.1 || uv.y > 0.9) {
        
        //  Display original signal in the margins
    	fragColor = vec4(texture(iChannel0, uv).rgb, 1.0);
        
    } else {
        
	    //  Compute sampling weights
    	float weights[N];
    	float sum = 0.0;
    	for (int n=0; n<N; n++) {
        	weights[n] = hann(float(n), float(N)) * sinc(FC * float(n-M));
        	sum += weights[n];
    	}
        
        //  Normalize sampling weights
        for (int n=0; n<N; n++) {
            weights[n] /= sum;
        }
        
        //	Sample composite signal and decode to YIQ
        vec3 YIQ = vec3(0.0);
        for (int n=0; n<N; n++) {
            vec2 pos = uv + vec2(float(n-M) / size.x, 0.0);
	        float phase = TAU * (SCF * size.x * pos.x);
            YIQ += vec3(1.0, cos(phase), sin(phase)) * texture(iChannel0, pos).rgb * weights[n];
        }
        
        //  Apply TV adjustments to YIQ signal and convert to RGB
        fragColor = vec4(YIQ2RGB * adjust(YIQ, HUE, SAT, BRI), 1.0);
    }
}
