function [center]=k_means(input,center,number_input,number_center,desired_output,class)

%% k-means algorithm for N centers
v=zeros(number_center,number_input);
distance=zeros(number_input,number_center);
flag=1;
epoch=1;

while flag==1
    % inizialize every cycle 
    v=zeros(number_center,number_input);
    E(epoch)=0;
    %calculate the energy function and the Voronoi cells
    for i=1:number_input
        if desired_output(i)==class
            for j=1:number_center
                distance(i,j)=(norm(input(:,i)-center(:,j)));
            end
            [dist,index]=min(distance(i,:));
            % if ind is a vector, take the first element
            if length(index)>1
                v(index(1),i)=1;
            elseif length(index)==1
                v(index,i)=1;
            end
            % compute energy
            E(epoch)=E(epoch)+dist^2;
        end
    end
    
    % update the centers to minimize energy
    for j=1:number_center
        x=0;
        Vi=0;
        for i=1:number_input
            if v(j,i)==1
                x=x+input(:,i);
                Vi=Vi+1;
            end
        end
        if Vi>0
            % update
            center(:,j)=x/Vi;
        end
    end
    
    % check loop condition
    if epoch>1
        if abs(E(epoch)-E(epoch-1))>1e-6
            flag=true;
        else
            flag=false;
        end
    end
    
    epoch=epoch+1;
end
end
