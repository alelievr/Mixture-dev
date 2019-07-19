Shader "Custom Texture Master"
{
    Properties
    {

    }
    SubShader
    {
    	Pass
    	{
    		Lighting Off
    		Blend One Zero

    		CGPROGRAM
    		#include "Assets/Mixture/Editor/CustomTextureShaderGraph/CustomRenderTexture.hlsl"
    		#pragma vertex CustomRenderTextureVertexShader
    		#pragma fragment frag
    		#pragma target 3.0

    		// TODO: put this in an include file
    		float4 SRGBToLinear( float4 c ) { return c; }
    		float3 SRGBToLinear( float3 c ) { return c; }
    		
    		bool IsGammaSpace()
    		{
    		#ifdef UNITY_COLORSPACE_GAMMA
    			return true;
    		#else
    			return false;
    		#endif
    		}

    		struct SurfaceDescriptionInputs
    		{
    			// update input values
    			float3 uv0;
    			float3 uv1;
    			uint primitiveID;
    			float3 direction;
    		};

    		SurfaceDescriptionInputs ConvertV2FToSurfaceInputs( v2f_customrendertexture IN )
    		{
    			SurfaceDescriptionInputs o;
    			
    			o.uv0 = IN.localTexcoord;
    			o.uv1 = IN.globalTexcoord;
    			o.primitiveID = IN.primitiveID;
    			o.direction = IN.direction;

    			return o;
    		}

    		///----------------------------------------------------------
    		/// Begin Generated Graph Code
    		///----------------------------------------------------------
        	    CBUFFER_START(UnityPerMaterial)
        CBUFFER_END


        void Unity_Checkerboard_float(float2 UV, float3 ColorA, float3 ColorB, float2 Frequency, out float3 Out)
        {
            UV = (UV.xy + 0.5) * Frequency;
            float4 derivatives = float4(ddx(UV), ddy(UV));
            float2 duv_length = sqrt(float2(dot(derivatives.xz, derivatives.xz), dot(derivatives.yw, derivatives.yw)));
            float width = 1.0;
            float2 distance3 = 4.0 * abs(frac(UV + 0.25) - 0.5) - width;
            float2 scale = 0.35 / duv_length.xy;
            float freqLimiter = sqrt(clamp(1.1f - max(duv_length.x, duv_length.y), 0.0, 1.0));
            float2 vector_alpha = clamp(distance3 * scale.xy, -1.0, 1.0);
            float alpha = saturate(0.5f + 0.5f * vector_alpha.x * vector_alpha.y * freqLimiter);
            Out = lerp(ColorA, ColorB, alpha.xxx);
        }

        struct SurfaceDescription
        {
            float4 Color;
        };

        SurfaceDescription PopulateSurfaceData(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float3 _Checkerboard_FAACF0F7_Out_4;
            Unity_Checkerboard_float(IN.uv0.xy, IsGammaSpace() ? float3(0.2, 0.2, 0.2) : SRGBToLinear(float3(0.2, 0.2, 0.2)), IsGammaSpace() ? float3(0.7, 0.7, 0.7) : SRGBToLinear(float3(0.7, 0.7, 0.7)), float2 (1, 1), _Checkerboard_FAACF0F7_Out_4);
            surface.Color = (float4(_Checkerboard_FAACF0F7_Out_4, 1.0));
            return surface;
        }


    		///----------------------------------------------------------
    		/// End Generated Graph Code
    		///----------------------------------------------------------

    		float4 frag(v2f_customrendertexture IN) : COLOR
    		{
    			SurfaceDescriptionInputs surfaceInput = ConvertV2FToSurfaceInputs(IN);

    			SurfaceDescription surf = PopulateSurfaceData(surfaceInput);

    			return surf.Color;
    		}
    		ENDCG
    	}
    }
    FallBack "Hidden/InternalErrorShader"
}
