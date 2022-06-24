Shader "Custom/blink"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _MaskTex ("Mask", 2D) = "white" {} // �κ� �ؽ��Ŀ��� �� �ʸ� ����ŷ�� �ؽ��ĸ� �޾ƿ� �������̽� �߰�
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        CGPROGRAM
        // Lambert ������ ���
        // Standart Lighting �� ����ص� ������, ������ ������ �����ϴٺ���
        // ������ ��¦�̴� �� ����� Ȯ���ϱ� ������� Lambert �����ð��� ������ �������� ����� ��.
        #pragma surface surf Lambert 

        sampler2D _MainTex;
        sampler2D _MaskTex; // �� ����ŷ �ؽ��ĸ� ��� ���÷� ���� ����

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_MaskTex; // �� ����ŷ �ؽ��ĸ� ���ø��� ���ؽ� uv��ǥ ����
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            float4 m = tex2D(_MaskTex, IN.uv_MaskTex); // �� ����ŷ �ؽ����� �ؼ����� ���ø���. (�� �κи� (1, 1, 1, 1), �������� (0, 0, 0, 0) �� ���ø��� ����.)
            o.Albedo = c.rgb;

            // �� �κ��� �������̵��� Bloom ȿ���� �ֱ� ���� 
            // Emission �� �� ����ŷ �ؼ����� g ������Ʈ ���� �κ� �ؽ��� ���� ���ؼ� �Ҵ���. 
            // (�� ������ �κ� ���� ���� 1�� ������ Emission ���� Albedo �� �������Ű�, ������ ������ 0�� �������� Emission ���� (0, 0, 0, 0)�� �Ҵ�Ǿ� ���� ���� �ƹ��� ������ ���ٰ���.) 
            o.Emission = c.rgb * m.g;

            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
