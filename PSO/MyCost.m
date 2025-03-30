function [z, sol]=MyCost(sol1,model)

    sol=ParseSolution(sol1,model);
    
    beta=model.vorbeta;
    z=sol.energy_sum+(beta*sol.Violation);

end