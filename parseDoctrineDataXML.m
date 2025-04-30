function doctrineStruct = parseDoctrineDataXML(xmlFile)
    % 读取 XML 文件
    xmlDoc = xmlread(xmlFile);
    % 若出现错误：“The string "--" is not permitted within comments.” 
    % 在 doctrine_nodes.xml 的出错位置，删除<!-- --> 注释行
    
    % 提取 DoctrineNodes 元素
    rootElement = xmlDoc.getElementsByTagName('DoctrineNodes').item(0);
    
    % 提取绑定的 Node 元素
    doctrineElements = rootElement.getElementsByTagName('Node');
    numDoctrines = doctrineElements.getLength();

    % 初始化结构体数组
    doctrineStruct = [];
    
    % 遍历每个 Node 元素
    for nodeIdx = 0:numDoctrines-1
        doctrineElement = doctrineElements.item(nodeIdx);
        
        % 初始化单个 Node 结构体
        currentDoctrine = struct();
        
        % 提取 Node 的属性
        currentDoctrine.name             = char(doctrineElement.getAttribute('name'));
        currentDoctrine.nameUI           = char(doctrineElement.getAttribute('nameUI'));
        currentDoctrine.description      = char(doctrineElement.getAttribute('description'));
        currentDoctrine.texturePrefix    = char(doctrineElement.getAttribute('texturePrefix'));

        % 提取 enable 元素
        EnableElements = doctrineElement.getElementsByTagName('Enable');
        numEnables = EnableElements.getLength();
        currentDoctrine.Enable = [];

        for i=0:numEnables-1
            current_enable_name = string(EnableElements.item(i).getAttribute('name'));
            currentDoctrine.Enable = [currentDoctrine.Enable; current_enable_name];
        end

        % 提取 AttackTypeModifier 元素

        % - minRange/maxRange interval needs to be defined and will only apply for attacktypes that cross into that interval
        % - if 'target' is not specified, the modifier will get applied to all attack types for all weapons
        % - if 'target' is specified, it can be either of:
        %     - the name of a specific firearm
        %     - the category of the firearm: pistol / rifle / shotgun / rpg / etc.
        %     - the name of a specific scope
        %     - the category of the scope (defined in the Scope as category="name")
        %     - the name of a specific attack type (in which case the minRange/maxRange interval doesn't need to be specified)
        % - if onlyFromCover="true" it will only apply the bonuses while shooter is in cover
        % - if onlyOnSuppressed="true" it will only apply the bonuses when the TARGET is suppressed

        attackTypeModifiers = doctrineElement.getElementsByTagName('AttackTypeModifier');
        numAttackTypeModifier = attackTypeModifiers.getLength();
        currentDoctrine.attackTypeModifiers = [];

        for i = 0:numAttackTypeModifier-1
            attackTypeModifier = attackTypeModifiers.item(i);

            currentAttackTypeModifier.target                  = char(attackTypeModifier.getAttribute('target'));
            currentAttackTypeModifier.onlyFromCover           = strcmp(char(attackTypeModifier.getAttribute('onlyFromCover'))   , 'true');
            currentAttackTypeModifier.onlyOnSuppressed        = strcmp(char(attackTypeModifier.getAttribute('onlyOnSuppressed')), 'true');

            currentAttackTypeModifier.minRange                = str2double0(attackTypeModifier.getAttribute('minRange'));
            currentAttackTypeModifier.maxRange                = str2double0(attackTypeModifier.getAttribute('maxRange'));
            currentAttackTypeModifier.minAimTimeAdd           = str2double0(attackTypeModifier.getAttribute('minAimTime'));
            currentAttackTypeModifier.maxAimTimeAdd           = str2double0(attackTypeModifier.getAttribute('maxAimTime'));
            currentAttackTypeModifier.accuracyAdd             = str2double0(attackTypeModifier.getAttribute('accuracyAdd'));
            currentAttackTypeModifier.followupShotAccuracyAdd = str2double0(attackTypeModifier.getAttribute('followupShotAccuracyAdd'));
            currentAttackTypeModifier.critChanceAdd           = str2double0(attackTypeModifier.getAttribute('critChanceAdd'));
            currentAttackTypeModifier.resetTimeAdd            = str2double0(attackTypeModifier.getAttribute('resetTime'));
            currentAttackTypeModifier.roundsPerSecondAdd      = str2double0(attackTypeModifier.getAttribute('roundsPerSecondAdd'));
            currentAttackTypeModifier.minShotsAdd             = str2double0(attackTypeModifier.getAttribute('minShots'));
            currentAttackTypeModifier.maxShotsAdd             = str2double0(attackTypeModifier.getAttribute('maxShots'));

            currentDoctrine.attackTypeModifiers = [currentDoctrine.attackTypeModifiers; currentAttackTypeModifier];
        end

        % 提取 EquipmentModifier 元素

        % - if 'target' is not specified, 
        %     - it will apply modifiers once, on the human directly. Used for stuff like "suppressionRecoveryAdd", melee bonuses and the global modifiers below
        % - if 'target' is specified, it can point to various things:
        %     - every piece of equipment if set to 'all'
        %     - the equipment name to which we're gonna apply the modifiers
        %     - an entire category of firearms: pistol / rifle / shotgun / rpg (defined in the firearm as category="name")
        %     - an entire category of equipment, specified by the equipment type: Firearm / Armor / Shield / Grenade / SpyCamera / ExplosiveCharge / Lockpick / LockpickMachine / Crowbar / DynamicHammer / SuicideBomb / Ammo / Scope / TECTorch / Disguise / Helmet / HelmetNVG / FeetOfSteel

        equipmentModifiers = doctrineElement.getElementsByTagName('EquipmentModifier');
        numEquipmentModifier = equipmentModifiers.getLength();
        currentDoctrine.equipmentModifiers = [];

        for i = 0:numEquipmentModifier-1
            equipmentModifierElem = equipmentModifiers.item(i);

            currentEquipmentModifier.target                 = char(equipmentModifierElem.getAttribute('target'));

            currentEquipmentModifier.reloadTimeAdd          = str2double0(equipmentModifierElem.getAttribute('reloadTime'));
            currentEquipmentModifier.reloadEmptyTimeAdd     = str2double0(equipmentModifierElem.getAttribute('reloadEmptyTime'));
            currentEquipmentModifier.changeInTimeAdd        = str2double0(equipmentModifierElem.getAttribute('changeInTime'));
            currentEquipmentModifier.changeOutTimeAdd       = str2double0(equipmentModifierElem.getAttribute('changeOutTime'));
            currentEquipmentModifier.readyTimeAdd           = str2double0(equipmentModifierElem.getAttribute('readyTime'));
            currentEquipmentModifier.accuracyStartAdd       = str2double0(equipmentModifierElem.getAttribute('accuracyStart'));
            currentEquipmentModifier.accuracyEndAdd         = str2double0(equipmentModifierElem.getAttribute('accuracyEnd'));
            currentEquipmentModifier.suppressionScaleAdd    = str2double0(equipmentModifierElem.getAttribute('suppressionScale'));
            currentEquipmentModifier.suppressionRecoveryAdd = str2double0(equipmentModifierElem.getAttribute('suppressionRecoveryAdd'));
            currentEquipmentModifier.conditioningAdd        = str2double0(equipmentModifierElem.getAttribute('conditioning'));
            currentEquipmentModifier.coverPercentAdd        = str2double0(equipmentModifierElem.getAttribute('coverPercentAdd'));
            currentEquipmentModifier.efficiencyPercent      = str2double0(equipmentModifierElem.getAttribute('efficiencyPercent'));
            currentEquipmentModifier.flinchResistance       = str2double0(equipmentModifierElem.getAttribute('flinchResistance'));
            currentEquipmentModifier.beingSpottedRate       = str2double0(equipmentModifierElem.getAttribute('beingSpottedRate'));
            currentEquipmentModifier.extraCoverage90        = str2double0(equipmentModifierElem.getAttribute('extraCoverage90'));
            currentEquipmentModifier.extraProtection90      = str2double0(equipmentModifierElem.getAttribute('extraProtection90'));
            currentEquipmentModifier.meleeDamageBonus       = str2double0(equipmentModifierElem.getAttribute('meleeDamageBonus'));
            currentEquipmentModifier.meleeStunBonus         = str2double0(equipmentModifierElem.getAttribute('meleeStunBonus'));
            currentEquipmentModifier.meleeSpeedAdd          = str2double0(equipmentModifierElem.getAttribute('meleeSpeedAdd'));

            currentDoctrine.equipmentModifiers = [currentDoctrine.equipmentModifiers; currentEquipmentModifier];
        end

        % 提取 GiveBuff元素
        Buffs = doctrineElement.getElementsByTagName('GiveBuff');
        numBuffs = Buffs.getLength();
        currentDoctrine.GiveBuff = [];

        for i=0:numBuffs-1
            buffElement = Buffs.item(i);

            current_buff.nodeName          = char(buffElement.getAttribute('nodeName'));
            current_buff.target            = char(buffElement.getAttribute('target'));  % "friends_in_radius", "enemies_in_radius", "friends_behind_me" or "self"(default)
            current_buff.targetClass       = char(buffElement.getAttribute('targetClass'));  
            current_buff.targetHasEquipped = char(buffElement.getAttribute('targetHasEquipped'));
            current_buff.when              = char(buffElement.getAttribute('when'));  % "kill" or "always"(default)
            current_buff.radius            = str2double(buffElement.getAttribute('radius')); 
            current_buff.durationMs        = str2double(buffElement.getAttribute('durationMs')); 

            if (isempty(current_buff.target))
                current_buff.target  = 'self';
            end
            if (isempty(current_buff.when))
                current_buff.when  = 'always';
            end

            if (isnan(current_buff.durationMs))
                current_buff.durationMs = -1;
            end

            currentDoctrine.GiveBuff = [currentDoctrine.GiveBuff; current_buff];
        end

        %
        doctrineStruct = [doctrineStruct; currentDoctrine];
    end


end
