function rifleStruct = parseRiflesXML(xmlFile)
    % 读取 XML 文件
    xmlDoc = xmlread(xmlFile);
    
    % 提取 Equipment 元素
    rootElement = xmlDoc.getElementsByTagName('Equipment').item(0);
    
    % 提取绑定的 Firearm 元素
    firearmElements = rootElement.getElementsByTagName('Firearm');
    numFirearms = firearmElements.getLength();

    % 初始化结构体数组
    rifleStruct = [];
    
    % 遍历每个 Firearm 元素
    for firearmIdx = 0:numFirearms-1
        firearmElement = firearmElements.item(firearmIdx);
        
        % 初始化单个 Firearm 结构体
        currentRifle = struct();
        
        % 提取 Firearm 的属性
        currentRifle.name             = char(firearmElement.getAttribute('name'));
        currentRifle.inventoryBinding = char(firearmElement.getAttribute('inventoryBinding'));
        currentRifle.category         = char(firearmElement.getAttribute('category'));
        currentRifle.unlockCost       = str2double(firearmElement.getAttribute('unlockCost'));
        currentRifle.tooltip          = char(firearmElement.getAttribute('tooltip'));
        currentRifle.description      = char(firearmElement.getAttribute('description'));
        currentRifle.img              = char(firearmElement.getAttribute('img'));
        currentRifle.animationSet     = char(firearmElement.getAttribute('animationSet'));
        
        % 提取 MobilityModifiers 元素
        mobilityModifiers = firearmElement.getElementsByTagName('MobilityModifiers').item(0);
        currentRifle.moveSpeedModifierPercent = str2double(mobilityModifiers.getAttribute('moveSpeedModifierPercent'));
        currentRifle.turnSpeedModifierPercent = str2double(mobilityModifiers.getAttribute('turnSpeedModifierPercent'));
        
        % 提取 ModifiableParams 元素
        modifiableParams                 = firearmElement.getElementsByTagName('ModifiableParams').item(0);
        currentRifle.numPellets          = str2double(modifiableParams.getAttribute('numPellets'));
        currentRifle.roundsPerMagazine   = str2double(modifiableParams.getAttribute('roundsPerMagazine'));
        currentRifle.closedBolt          = str2double(modifiableParams.getAttribute('closedBolt'));
        currentRifle.cyclicReload        = str2double(modifiableParams.getAttribute('cyclicReload'));
        currentRifle.reloadTime          = str2double(modifiableParams.getAttribute('reloadTime'));
        currentRifle.reloadEmptyTime     = str2double(modifiableParams.getAttribute('reloadEmptyTime'));
        currentRifle.changeInTime        = str2double(modifiableParams.getAttribute('changeInTime'));
        currentRifle.changeOutTime       = str2double(modifiableParams.getAttribute('changeOutTime'));
        currentRifle.readyTime           = str2double(modifiableParams.getAttribute('readyTime'));
        currentRifle.guardTime           = str2double(modifiableParams.getAttribute('guardTime'));
        currentRifle.accuracyStart       = str2double(modifiableParams.getAttribute('accuracyStart'));
        currentRifle.accuracyEnd         = str2double(modifiableParams.getAttribute('accuracyEnd'));
        currentRifle.accuracyStartDist   = str2double(modifiableParams.getAttribute('accuracyStartDist'));
        currentRifle.accuracyEndDist     = str2double(modifiableParams.getAttribute('accuracyEndDist'));
        currentRifle.suppressionScale    = str2double(modifiableParams.getAttribute('suppressionScale'));
        
        % 提取 Params 元素
        params                           = firearmElement.getElementsByTagName('Params').item(0);
        currentRifle.operationInfoText   = char(params.getAttribute('operationInfoText'));
        currentRifle.caliberInfoText     = char(params.getAttribute('caliberInfoText'));
        currentRifle.ejectingShellEntity = char(params.getAttribute('ejectingShellEntity'));
        currentRifle.ai_rangeMin         = str2double(params.getAttribute('ai_rangeMin'));
        currentRifle.ai_rangeOptimal     = str2double(params.getAttribute('ai_rangeOptimal'));
        currentRifle.ai_rangeMax         = str2double(params.getAttribute('ai_rangeMax'));
        currentRifle.ai_stopWhenShooting = strcmp(params.getAttribute('ai_stopWhenShooting'), 'true');
        
        % 提取 AttackTypes 元素
        attackTypes = firearmElement.getElementsByTagName('AttackTypes').item(0);
        
        if (isempty(attackTypes))  % enemy's RPG does not have AttackTypes
            continue;
        end

        attackTypeElements = attackTypes.getElementsByTagName('AttackType');
        numAttacks = attackTypeElements.getLength();
        current_attack_type = [];
        currentRifle.attackTypes = [];
        
        for i = 0:numAttacks-1
            attackTypeElement = attackTypeElements.item(i);
            current_attack_type.name = char(attackTypeElement.getAttribute('name'));

            current_attack_type.rangeMeters = str2double(attackTypeElement.getAttribute('rangeMeters'));
            current_attack_type.disabled = 'false';
            current_attack_type.inCoverOverride = char(attackTypeElement.getAttribute('inCoverOverride'));

            if (strcmp(attackTypeElement.getAttribute('disabled'), "true"))
                current_attack_type.disabled = 'true';
            end

            currentRifle.attackTypes =[currentRifle.attackTypes; current_attack_type];

        end


        % 提取 MuzzleFlash 元素
        % muzzleFlash = firearmElement.getElementsByTagName('MuzzleFlash').item(0);
        % flareElements = muzzleFlash.getElementsByTagName('Flare');
        % numFlares = flareElements.getLength();
        % currentRifle.muzzleFlash = cell(1, numFlares);
        % for i = 0:numFlares-1
        %     flareElement = flareElements.item(i);
        %     currentRifle.muzzleFlash{i+1} = char(flareElement.getAttribute('particles'));
        % end
        
        % 提取 Sounds 元素
        % sounds = firearmElement.getElementsByTagName('Sounds').item(0);
        % soundElements = sounds.getElementsByTagName('*');
        % numSounds = soundElements.getLength();
        % currentRifle.sounds = struct();
        % for i = 0:numSounds-1
        %     soundElement = soundElements.item(i);
        %     soundName = char(soundElement.getNodeName());
        %     currentRifle.sounds.(soundName) = char(soundElement.getAttribute('name'));
        % end
        
        % 将提取的单个 Firearm 数据添加到 Firearms 数组
        rifleStruct = [rifleStruct; currentRifle];
    end


end
