function meanRoi = meanRoiVol( volume, mask )

imgVolu = load_nii( volume );
if(ischar(mask))
    imgMask = load_nii( mask );
else
    imgMask = mask;
end

meanRoi = mean(imgVolu.img( imgMask.img~=0 ));

end