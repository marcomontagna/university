function [c]=k_means(in,c,n_in,n_c,d,class)

%% k-means 
distance=zeros(n_in,n_c);
v=zeros(n_c,n_in);
flag=1;
epoch=1;

while flag==1
    v=zeros(n_c,n_in);
    E(epoch)=0;
    % loop energy function
    % vonronoi cells
    for i=1:n_in
        if d(i)==class
            for j=1:n_c
                distance(i,j)=(norm(in(:,i)-c(:,j)));
            end
            [dist,ind]=min(distance(i,:));
            if length(ind)>1
                v(ind(1),i)=1;
            elseif length(ind)==1
                v(ind,i)=1;
            end
            % compute energy function
            E(epoch)=E(epoch)+dist^2;
        end
    end
    
    % update centres
    % minimize energy
    for j=1:n_c
        x=0;
        vi=0;
        for i=1:n_in
            if v(j,i)==1
                x=x+in(:,i);
                vi=vi+1;
            end
        end
        if vi>0
            c(:,j)=x/vi;
        else 
            flag=1;
            % loop for recalculating the centre
            while flag==1
                c(:,j)=rand(2,1);
                if (class==1 && (c(2,j)<(1/5)*sin(10*c(1,j))+0.3 || (c(2,j)-0.8)^2+(c(1,j)-0.5)^2<0.15^2)) || (class==-1 && ~(c(2,j)<(1/5)*sin(10*c(1,j))+0.3 || (c(2,j)-0.8)^2+(c(1,j)-0.5)^2<0.15^2)) 
                j=j-1;
                flag=0;
                end
            end
        end
    end
    
    % loop check
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
