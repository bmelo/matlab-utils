function organizeConditions( obj )

if(isstruct(obj.conditions)) %não deve fazer nada
  return
end
[rows cols] = size(obj.conditions); %se houver só uma linha, indica que foi entrado um cell com conditions diferentes para cada run
if(rows == 1)
  strCond = struct();
  for nses = 1:cols
    condsSess = obj.conditions{nses};
    for ncond = 1:size(condsSess,1)
      strCond.sess(nses).cond(ncond).name = condsSess{ncond, 1};
      strCond.sess(nses).cond(ncond).onset = condsSess{ncond, 2};
      strCond.sess(nses).cond(ncond).duration = condsSess{ncond, 3};
    end
  end
  obj.conditions = strCond;
end

end

