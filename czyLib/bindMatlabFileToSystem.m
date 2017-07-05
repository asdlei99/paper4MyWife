function bindMatlabFileToSystem

%     cwd=pwd;
%     cd([matlabroot '\toolbox\matlab\winfun\private']);
%     fileassoc('add',{'.m','.mat','.fig','.p','.mdl',['.' mexext]}); %�ص�
%     cd(cwd);
%     disp('Changed Windows file associations. FIG, M, MAT, MDL, MEX, and P files are now associated with MATLAB.')
%     
    cwd=pwd;  
    cd([matlabroot '\mcr\toolbox\matlab\winfun\private']);  
    fileassoc('add',{'.mat','.fig','.p','.mdl',['.' mexext]});  
    cd(cwd);  
    disp('Changed Windows file associations. FIG, M, MAT, MDL, MEX, and P files are now associated with MATLAB.');  
end