Shader "Unlit/TextureArrayOutput"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        [HideInInspector] _SliceIndex ("Index", float) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                uint depthSlice : SV_RenderTargetArrayIndex;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _SliceIndex;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.depthSlice = _SliceIndex;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                float3 col = 1;

                if (_SliceIndex % 2)
                    col = float3(i.uv, 0);
                else
                    col = float3(0, i.uv);

                return float4(col, 1);
            }
            ENDCG
        }
    }
}
