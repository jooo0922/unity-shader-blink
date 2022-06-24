Shader "Custom/blink"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        CGPROGRAM
        // Lambert 라이팅 사용
        // Standart Lighting 을 사용해도 좋으나, 라이팅 구조가 복잡하다보니
        // 눈빛이 반짝이는 걸 제대로 확인하기 어려워서 Lambert 라이팅같은 간단한 라이팅을 사용한 것.
        #pragma surface surf Lambert 

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            o.Albedo = c.rgb;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
