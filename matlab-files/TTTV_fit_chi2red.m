function [chi2red] = TTTV_fit_chi2red( planet_n, planet_OC, planet_OCe, OC )


chi2=zeros;
i=2;
while i<= length(planet_n)
    
    chi2(i)=(((planet_OC(i))-OC(planet_n(i)))^2)/((planet_OCe(i)^2));
    
i=i+1;
end

chi2red= sum(chi2)/length(planet_n);


end

