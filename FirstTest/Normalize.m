function [Normalized_data ] = Normalize( Input_data)
%To Normalize given data 
Normalized_data=Input_data-repmat(mean(Input_data),length(Input_data),1)./repmat(std(Input_data),length(Input_data),1);

end

