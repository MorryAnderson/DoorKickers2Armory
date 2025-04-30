function ammoStruct = parseAmmoXML(xmlFile)
    % 读取 XML 文件
    xmlDoc = xmlread(xmlFile);
    
    % 提取 Equipment 元素
    rootElement = xmlDoc.getElementsByTagName('Equipment').item(0);
    
    % 获取所有 Ammo 元素
    ammoElements = rootElement.getElementsByTagName('Ammo');
    numAmmo = ammoElements.getLength();
    
    % 初始化结构体数组
    ammoStruct = [];
    
    % 遍历每个 Ammo 元素
    for i = 0:numAmmo-1
        ammoElement = ammoElements.item(i);
        
        % 创建一个新的结构体来存储每个 Ammo 的数据
        currentAmmo = struct();
        
        % 提取 Ammo 的属性
        % currentAmmo.name           = swapUnderscoreParts(char(ammoElement.getAttribute('name')));
        currentAmmo.name           = char(ammoElement.getAttribute('name'));
        currentAmmo.tooltip        = char(ammoElement.getAttribute('tooltip'));
        currentAmmo.description    = char(ammoElement.getAttribute('description'));
        currentAmmo.img            = char(ammoElement.getAttribute('img'));
        
        % 提取 Params 元素
        paramsElement                  = ammoElement.getElementsByTagName('Params').item(0);
        currentAmmo.roundsPerSecond    = str2double(paramsElement.getAttribute('roundsPerSecond'));
        currentAmmo.audibleSoundRadius = str2double(paramsElement.getAttribute('audibleSoundRadius'));
        currentAmmo.physicsImpactForce = str2double(paramsElement.getAttribute('physicsImpactForce'));
    
        currentAmmo.numPellets         = str2double(paramsElement.getAttribute('numPellets'));
        currentAmmo.accuracyAdd        = str2double0(paramsElement.getAttribute('accuracyAdd'));
        currentAmmo.accuracyMultiplier = str2double(paramsElement.getAttribute('accuracyMultiplier'));
        currentAmmo.silenced           = str2double0(paramsElement.getAttribute('silenced'));
        currentAmmo.overpenetrates     = str2double0(paramsElement.getAttribute('overpenetrates'));
        currentAmmo.damageType         = str2double0(paramsElement.getAttribute('damageType'));

        if (isnan(currentAmmo.accuracyMultiplier))
            currentAmmo.accuracyMultiplier = 100; 
        end

        % 提取 Damage 元素
        damageElement               = ammoElement.getElementsByTagName('Damage').item(0);
        currentAmmo.damageStart     = str2double(damageElement.getAttribute('start'));
        currentAmmo.damageEnd       = str2double(damageElement.getAttribute('end'));
        currentAmmo.damageStartDist = str2double(damageElement.getAttribute('startDist'));
        currentAmmo.damageEndDist   = str2double(damageElement.getAttribute('endDist'));
        
        % 提取 CriticalChancePercent 元素
        criticalChanceElement         = ammoElement.getElementsByTagName('CriticalChancePercent').item(0);
        currentAmmo.criticalStart     = str2double(criticalChanceElement.getAttribute('start'));
        currentAmmo.criticalEnd       = str2double(criticalChanceElement.getAttribute('end'));
        currentAmmo.criticalStartDist = str2double(criticalChanceElement.getAttribute('startDist'));
        currentAmmo.criticalEndDist   = str2double(criticalChanceElement.getAttribute('endDist'));
        
        % 提取 ArmorPenetration 元素
        armorPenetrationElement          = ammoElement.getElementsByTagName('ArmorPenetration').item(0);
        currentAmmo.penetrationStart     = str2double(armorPenetrationElement.getAttribute('start'));
        currentAmmo.penetrationEnd       = str2double(armorPenetrationElement.getAttribute('end'));
        currentAmmo.penetrationStartDist = str2double(armorPenetrationElement.getAttribute('startDist'));
        currentAmmo.penetrationEndDist   = str2double(armorPenetrationElement.getAttribute('endDist'));
        
        % 将当前 Ammo 的数据存储到结构体数组中
        ammoStruct = [ammoStruct; currentAmmo];
    end
end
