

if (player getvariable ["tpw_stowgun",0] == 0) then 
    { 
        { 
        _gun = primaryweapon _x; 
        _x setvariable ["tpw_gun",_gun]; 
        unitbackpack _x addItemCargo [_gun,1];  
        _x removeweapon _gun; 
        } foreach units (group player); 
    player setvariable ["tpw_stowgun",1]; 
    } 
    else 
    { 
        { 
        _gun = _x getvariable "tpw_gun"; 
        _x removeItem _gun;  
        _x addweapon _gun; 
        } foreach units (group player); 
    player setvariable ["tpw_stowgun",0]; 
}; 