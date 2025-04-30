function scopesStruct = parseScopeXML(xmlFile)
    % 读取 XML 文件
    xmlDoc = xmlread(xmlFile);
    
    % 提取 Equipment 元素
    rootElement = xmlDoc.getElementsByTagName('Equipment').item(0);
    
    % 获取所有 Scope 元素
    scopeElements = rootElement.getElementsByTagName('Scope');
    numScopes = scopeElements.getLength();
    
    % 初始化结构体数组
    scopesStruct = [];
    
    % 循环处理每个 Scope 元素
    for i = 0:numScopes-1
        % 创建当前 Scope 结构体
        currentScope = struct();
        
        scopeElement = scopeElements.item(i);
        
        % 提取 Scope 元素的属性并存储到 currentScope
        currentScope.name             = char(scopeElement.getAttribute('name'));
        currentScope.unlockCost       = str2double(scopeElement.getAttribute('unlockCost'));
        currentScope.inventoryBinding = char(scopeElement.getAttribute('inventoryBinding'));
        currentScope.tooltip          = char(scopeElement.getAttribute('tooltip'));
        currentScope.description      = char(scopeElement.getAttribute('description'));
        currentScope.category         = char(scopeElement.getAttribute('category'));
        currentScope.img              = char(scopeElement.getAttribute('img'));
        
        % 提取 RenderObject3D 元素
        % renderObject3D = scopeElement.getElementsByTagName('RenderObject3D').item(0);
        % if (~isempty(renderObject3D)) 
            % currentScope.renderObject3D.model = char(renderObject3D.getAttribute('model'));
            % currentScope.renderObject3D.attachSlot = char(renderObject3D.getAttribute('attachSlot'));
            % currentScope.renderObject3D.skipGOSSAO = strcmp(renderObject3D.getAttribute('skipGOSSAO'), 'true');
            % currentScope.renderObject3D.diffuseTex = char(renderObject3D.getAttribute('diffuseTex'));
        % end
        
        % 提取 MobilityModifiers 元素
        mobilityModifiers = scopeElement.getElementsByTagName('MobilityModifiers').item(0);
        if (~isempty(mobilityModifiers)) 
            currentScope.moveSpeedModifierPercent = str2double(mobilityModifiers.getAttribute('moveSpeedModifierPercent'));
            currentScope.turnSpeedModifierPercent = str2double(mobilityModifiers.getAttribute('turnSpeedModifierPercent'));
        else 
            currentScope.moveSpeedModifierPercent = 0;
            currentScope.turnSpeedModifierPercent = 0;       
        end
        
        % 提取 Params 元素
        params                       = scopeElement.getElementsByTagName('Params').item(0);
        equipmentModifier            = params.getElementsByTagName('EquipmentModifier').item(0);
        if (~isempty(equipmentModifier))
            currentScope.changeOutTime   = str2double0(equipmentModifier.getElementsByTagName('AddTo').item(0).getAttribute('changeOutTime'));
            currentScope.reloadTime      = str2double0(equipmentModifier.getElementsByTagName('AddTo').item(0).getAttribute('reloadTime'));
            currentScope.reloadEmptyTime = str2double0(equipmentModifier.getElementsByTagName('AddTo').item(0).getAttribute('reloadEmptyTime'));
            currentScope.readyTime       = str2double0(equipmentModifier.getElementsByTagName('AddTo').item(0).getAttribute('readyTime'));
        else 
            currentScope.changeOutTime   = 0;
            currentScope.reloadTime      = 0;
            currentScope.reloadEmptyTime = 0;
            currentScope.readyTime       = 0;
        end

        % 提取 AttackTypeModifier 元素
        attackTypeModifiers = params.getElementsByTagName('AttackTypeModifier');
        numModifiers = attackTypeModifiers.getLength();
        if (numModifiers == 0)
            continue;
        end
        currentScope.attackTypeModifiers = [];
        
        for j = 0:numModifiers-1
            attackTypeModifier = attackTypeModifiers.item(j);
            
            % 创建当前 AttackTypeModifier 结构体
            currentModifier = struct();
            
            currentModifier.minRange = str2double(attackTypeModifier.getAttribute('minRange'));
            currentModifier.maxRange = str2double(attackTypeModifier.getAttribute('maxRange'));
            
            addTo = attackTypeModifier.getElementsByTagName('AddTo').item(0);

            currentModifier.minAimTime2   = str2double0(addTo.getAttribute('minAimTime2'));
            currentModifier.maxAimTime2   = str2double0(addTo.getAttribute('maxAimTime2'));
            currentModifier.resetTime     = str2double0(addTo.getAttribute('resetTime'));
            currentModifier.accuracyAdd   = str2double0(addTo.getAttribute('accuracyAdd'));
            currentModifier.critChanceAdd = str2double0(addTo.getAttribute('critChanceAdd'));
            
            % 将当前 Modifier 添加到 attackTypeModifiers 数组
            currentScope.attackTypeModifiers = [currentScope.attackTypeModifiers; currentModifier];
        end
        
        % 将当前 Scope 添加到 scopesStruct 数组
        scopesStruct = [scopesStruct; currentScope];
    end
end
