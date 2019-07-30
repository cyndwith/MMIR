function jH = jointHistogram(movingIMG,fixedIMG)
movingIMG = im2uint8(movingIMG);
fixedIMG = im2uint8(fixedIMG);
% jH = zeros(size(IMG3));
jH = zeros(255,255);
x = min(size(movingIMG,1),size(fixedIMG,1));
y = min(size(movingIMG,2),size(fixedIMG,2));
for i = 1:x
    for j = 1:y
        jH(fixedIMG(i,j)+1,movingIMG(i,j)+1) = jH(fixedIMG(i,j)+1,movingIMG(i,j)+1)+1;
    end
end
