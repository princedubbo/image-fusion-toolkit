��Щ�д������ҵģ������Լ�д�ģ�����Ҳ�д��󣬴�jia������
data.M1,data.M2�ֱ�Ϊ�ں�ǰ������ͼ��data.FΪ�ںϺ��ͼ��

    avg=num2str(avg_gradient(data.F));%ƽ���ݶ�

    ein=num2str(edge_intensity(data.F));%��Եǿ��

    sha=num2str(shannon(data.F));%��Ϣ��

    [img_mean,img_var]=variance(data.F);%�ҶȾ�ֵ����׼��(������MSE)
    gray_mean=num2str(img_mean);
    vari=num2str(img_var);

    rms=num2str(rmse(data.F,data.M1));%���������

    psnrvalue=num2str(psnr(data.M1,data.F));%��ֵ�����

    sf=num2str(space_frequency(data.F));%�ռ�Ƶ��

    fd=num2str(figure_definition(data.F));%ͼ��������

    mi1=mutinf(data.M1,data.F);%����Ϣ

    mi2=mutinf(data.M2,data.F);
    mi=num2str(mi1+mi2);
    [mssim, ssim_map] = ssim(data.M1,data.F);%�ṹ������
    ssi=num2str(mssim);

    cross_entro=num2str(cross_entropy(data.M1,data.M2));%�����أ�Ӧ��ʹ�ñ�׼ͼ��&�ںϺ�ͼ��

    rw=num2str(relatively_warp(data.M1,data.F));%��Ա�׼�Ӧ��ʹ�ñ�׼ͼ��&�ںϺ�ͼ��