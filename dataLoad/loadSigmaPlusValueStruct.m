function sigmaPlusValueStruct = loadSigmaPlusValueStruct(sigmaPlusValueStructPath)
%�����˹���ȡ�����ݽṹ sigmaPlusValue
    st = load(sigmaPlusValueStructPath);
    sigmaPlusValueStruct = st.st;
end

