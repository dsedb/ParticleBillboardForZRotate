Shader "Custom/billboard"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
	}
	SubShader
	{
   		Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" }
		ZWrite Off
		Cull Off
		Blend SrcAlpha One

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
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
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			
			v2f vert (appdata v)
			{
				float4 tv = v.vertex;
				float3 up = float3(0, 1, 0);
				float3 eye = normalize(ObjSpaceViewDir(tv));
				float3 tangent = normalize(cross(eye, up));
				float3 binormal = cross(eye, tangent);
				float size = 1;
				float3 vec = ((v.uv.x-0.5f)*tangent + (v.uv.y-0.5f)*binormal)*size;

				v2f o;
				// o.vertex = UnityObjectToClipPos(v.vertex);
				o.vertex = UnityObjectToClipPos(tv + vec);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.uv);
				return col;
			}
			ENDCG
		}
	}
}
