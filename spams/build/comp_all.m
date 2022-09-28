files = dir(strcat(pwd,'/mex*.m'));

for i = 1:length(files)
    i
     filename = [files(i).folder,filesep,files(i).name];
     mex filename
end