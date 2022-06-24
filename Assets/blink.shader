Shader "Custom/blink"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _MaskTex ("Mask", 2D) = "white" {} // 로봇 텍스쳐에서 눈 쪽만 마스킹한 텍스쳐를 받아올 인터페이스 추가
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
        sampler2D _MaskTex; // 눈 마스킹 텍스쳐를 담는 샘플러 변수 선언

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_MaskTex; // 눈 마스킹 텍스쳐를 샘플링할 버텍스 uv좌표 선언
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            float4 m = tex2D(_MaskTex, IN.uv_MaskTex); // 눈 마스킹 텍스쳐의 텍셀값을 샘플링함. (눈 부분만 (1, 1, 1, 1), 나머지는 (0, 0, 0, 0) 을 샘플링할 것임.)
            o.Albedo = c.rgb;

            // 눈 부분이 빛나보이도록 Bloom 효과를 주기 위해 
            // Emission 에 눈 마스킹 텍셀값의 g 컴포넌트 값을 로봇 텍스쳐 색상에 곱해서 할당함. 
            // (눈 영역은 로봇 눈깔 색상에 1이 곱해진 Emission 값이 Albedo 에 더해질거고, 나머지 영역은 0이 곱해져서 Emission 값은 (0, 0, 0, 0)이 할당되어 최종 색상에 아무런 영향을 안줄거임.) 
            o.Emission = c.rgb * m.g;

            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
