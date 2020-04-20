<< 
local cost = wesnoth.get_variable "Recall_Zero_cost"

for _, unit in ipairs(wesnoth.get_recall_units {}) do
    if unit.level == 0 then
        unit.recall_cost = cost
    end
end
>>
