function sigmaPlusValueStruct = loadSigmaPlusValueStruct(sigmaPlusValueStructPath)
%加载人工读取的数据结构 sigmaPlusValue
    st = load(sigmaPlusValueStructPath);
    sigmaPlusValueStruct = st.sigmaPlusValue;
end

