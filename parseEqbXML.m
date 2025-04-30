function eqbStruct = parseEqbXML(xmlFile)
    % 读取 XML 文件
    xmlDoc = xmlread(xmlFile);
    
    % 提取 Equipment 元素
    rootElement = xmlDoc.getElementsByTagName('Equipment').item(0);

    % 获取所有 Bind 元素
    eqbElements = rootElement.getElementsByTagName('Bind');
    numEqb = eqbElements.getLength();

    % 初始化结构体数组
    eqbStruct = [];
    
    % 遍历每个 eqb 元素
    for n=0:numEqb-1
        eqbElement = eqbElements.item(n);

        % 创建一个新的结构体来存储每个 eqb 的数据
        currentEqb = struct();

        % 提取 eqp 属性
        currentEqb.name = char(eqbElement.getAttribute('eqp'));
        
        % 获取所有 to 元素
        toElements = eqbElement.getElementsByTagName('to');
        numToElements = toElements.getLength();
        
        i_type = 0;
        i_ammo  = 0;
        i_scope = 0;
        
        currentEqb.type = strings(0,1);
        currentEqb.ammo = strings(0,1);
        currentEqb.scope = strings(0,1);

        % 遍历每个 to 元素
        for i = 0:numToElements-1
            toElement = toElements.item(i);
            toName = char(toElement.getAttribute('name'));
            
            if (isstrprop(toName(1), 'digit'))
                i_ammo = i_ammo + 1;
                currentEqb.ammo(i_ammo,1) = toName;
            else
                if (i_ammo > 0)  % scope
                    i_scope = i_scope + 1;
                    currentEqb.scope(i_scope,1) = toName;
                else  % type
%                     if (toName ~= "Medic")
                        i_type = i_type + 1;
                        currentEqb.type(i_type,1) = toName;
%                     end
                end
            end
        end


        eqbStruct = [eqbStruct; currentEqb];
    end


end
