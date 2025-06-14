/*
	MIT Licensed:

	Copyright (c) 2017 Lucas Melo

	Permission is hereby granted, free of charge, to any person obtaining a copy
	of this software and associated documentation files (the "Software"), to deal
	in the Software without restriction, including without limitation the rights
	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the Software is
	furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in all
	copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
	SOFTWARE.
*/

#include "ReShade.fxh"
#include "ReShadeUI.fxh"


uniform float3x3 Kernel = float3x3(
	1.0, 2.0, 1.0,
	0, 0, 0,
	-1.0, -2.0, -1.0);
	
float4 applySobel(float4 vpos : SV_Position, float2 texcoord : TEXCOORD) : SV_Target{
	float3 Dx = float3(0,0,0);
	float3 Dy = float3(0,0,0);
	
	for(int x = -1; x <= 1; x++) {
		for(int y = -1; y <= 1; y++) {
			float3 color = tex2D(ReShade::BackBuffer, clamp(texcoord+ReShade::PixelSize*float2(x,y), 0, 1)).rgb;
			
			Dx+=color*Kernel[x+1][y+1];
			Dy+=color*Kernel[y+1][x+1];
		}
	}
	float3 finalColor = sqrt(Dx*Dx+Dy*Dy);
	return float4(saturate(finalColor), 1.0);
}
	
    // Technique definition
technique SobelEdgeDetection {
	pass {
		PixelShader = applySobel;
		VertexShader = PostProcessVS;
	}
}


