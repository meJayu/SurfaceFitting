function analysePlots(grayImage,modeledColorChannel,p) 

        %extract the diagonal pixel locations
        [P,Q] = size(grayImage);
        M = 1.3338;C = P;
        X = [1:Q]';
        Y = round(((M.*X + C) - C)./1.7778);
        %extract diagonal pixel intensities and obtaine the residuals
        p1 = impixel(grayImage,X,Y);
        p2 = impixel(modeledColorChannel,X,Y);
        p1 = p1(:,1);p2 = p2(:,1);
        
        x = p1 - p2 ; % residuals along the diagonals
        q1 = grayImage(:);
        q2 = modeledColorChannel(:);
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% Different plots to check the behaviour of residuals and fit
        
        %(1). check the non-linearity assumption
        % Residual PLOT : Although it is common convention to draw this plot
        % as residual values on verticle axis and predictor variables on x
        % axis, since we have 2 predictor variables, for easy analysis in
        % 2D plots, we are taking ESTIMATED responce variable(y^) in stead of predictor.
        
        figure,stem(p2,x,'filled','LineStyle','none','Color','r','MarkerSize',3);
        title('Residual plot');
        xlabel('Fitted Values');ylabel('Residuals');
        
        
        %(2)check the non constancy of error varience
        %Absolute Residual plots: Same as the residual plots above but
        %instead of residuals, here residuals' squares are plotted against
        %the estimated responce variable or fitted values.
        
        figure,stem(p2,x.^2,'filled','LineStyle','none','Color','r','MarkerSize',3);
        title('Squared Residual plot');
        xlabel('Fitted Values');ylabel('Residuals'' square');
        
        %(3)To check the non-ZERO covarience between two consecutive residuals
        %Sequence plot of Residual: residuals are plotted in sequence of
        %locations along with the diaginal line shown in the image, to
        %ckeck the correlation between the residuals.
        
        figure,stem(x,'filled','LineStyle','none','Color','b','MarkerSize',3);
        title('Sequence plot of Residuals');
        xlabel('Pixel locations along the diagonal line');ylabel('Residuals');
                
        %(4)Non-normality of the residuals
        %Normal Probability plots: see the detailed text of how to draw
        %this plots in the reference given in the text.
        % Histogram of residuals is also useful to check such normality
        
        %k = floor(tiedrank(q1-q2));
        [~,~,k] = unique(x);
        vl = (k - 0.375)./(length(x) + 0.25);
        Z = zscore(vl);
        xa = sqrt(p.RMSE) .* Z;
        figure,plot(xa,x,'k.');
        title('Normal Probability plot of Residuals');
        xlabel('Expected value of Residuals under Normality');ylabel('Residuals');
        
        % histogram of pixel values along the diagonal line
        figure,histogram(x);
        title('Histogram of Residuals along the diagonal');
        
        %histogram of all residual values
        figure,histogram(q1-q2);
        title('Histogram of residuals');
        
        %QQ plot to check the normal distributions of residuals
        %figure,qqplot(x);
        %title('QQ plot of Residual vs. Standard normal');
        %xlabel('Standard Normal Quantiles');ylabel('Quantiles of Residuals');
        
        %symmetry plots to check the linearity of model
        figure,plot(p1,'r*');hold on;
        plot(p2,'k-');
        hold off;
        xlabel('Fitted Values'); ylabel('Intensity');
        legend('Observed Intensity Values','Estimated Intensity Values');
        

        
        


end
