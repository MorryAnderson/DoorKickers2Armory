function attackStruct = parseAttackXML(xmlFile)
    % 读取 XML 文件
    xmlDoc = xmlread(xmlFile);
    
    % 提取 Equipment 元素
    rootElement = xmlDoc.getElementsByTagName('FirearmAttackTypes').item(0);
    
    % 获取所有 Attack 元素
    attackElements = rootElement.getElementsByTagName('AttackType');
    numAttack = attackElements.getLength();
    
    % 初始化结构体数组
    attackStruct = [];
    
    % 遍历每个 Attack 元素
    for i = 0:numAttack-1
        attackElement = attackElements.item(i);
        modifiableParams = attackElement.getElementsByTagName('ModifiableParams').item(0);
        
        % 创建一个新的结构体来存储每个 Attack 的数据
        currentAttack = struct();
        
        % 提取 Attack 的属性
        currentAttack.name                    = char(attackElement.getAttribute('name'));
        currentAttack.minAimTime              = str2double(modifiableParams.getAttribute('minAimTime'));
        currentAttack.maxAimTime              = str2double(modifiableParams.getAttribute('maxAimTime'));
        currentAttack.roundsPerSecondOverride = str2double(modifiableParams.getAttribute('roundsPerSecondOverride'));
        currentAttack.minShots                = str2double(modifiableParams.getAttribute('minShots'));
        currentAttack.maxShots                = str2double(modifiableParams.getAttribute('maxShots'));
        currentAttack.resetTime               = str2double(modifiableParams.getAttribute('resetTime'));
        currentAttack.accuracyAdd             = str2double0(modifiableParams.getAttribute('accuracyAdd'));
        currentAttack.followupShotAccuracyAdd = str2double0(modifiableParams.getAttribute('followupShotAccuracyAdd'));
        currentAttack.critChanceAdd           = str2double0(modifiableParams.getAttribute('critChanceAdd'));

        % 将当前 Attack 的数据存储到结构体数组中
        attackStruct = [attackStruct, currentAttack];
    end
end
