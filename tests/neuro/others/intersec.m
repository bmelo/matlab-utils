function intersec(img1, img2, name_save)

img1.img( img1.img~=0 ) = 1;
img2.img( img2.img~=0 ) = 1;
posicoesLimpar = (img1.img ~= img2.img);
img1.img(posicoesLimpar) = 0;
save_nii(img1, name_save);

end