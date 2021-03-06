function displayPSFs()

    goodSubjects = [4 8 9];  % The best subjects
    
    % Compute good subject PSFs along the Y = 0, negative X, with an
    % eccentricity resolution of 1 deg
    eccXrange = [-20 0];
    eccYrange = [0 0];
    deltaEcc = 1;
    
    imposedRefractionErrorDiopters = 0;
    
    plotlabOBJ = setupPlotLab();
    cMap = brewermap(512, 'greys');
     
    if (1==2)
        % Compute the PSFs at the desired eccentricities
        [hEcc, vEcc, thePSFs, thePSFsupportDegs] = CronerKaplanRGCModel.psfAtEccentricity(goodSubjects, ...
            imposedRefractionErrorDiopters, eccXrange, eccYrange, deltaEcc);

        % Visualize them
        hFig = figure(1); clf;
        set(hFig, 'Position', [10 10 28 16])
        theAxesGrid = plotlab.axesGrid(hFig, ...
                'rowsNum', numel(goodSubjects), ...
                'colsNum', numel(hEcc), ...
                'leftMargin', 0.005, ...
                'rightMargin', 0.005, ...
                'widthMargin', 0.005, ...
                'heightMargin', 0.005, ...
                'bottomMargin', 0.005, ...
                'topMargin', 0.005);
        
       
        psfRangeDegs = 0.1;
        for subjIdx = 1:numel(goodSubjects)
           for eccYIndex = 1:numel(vEcc)
           for eccXIndex = 1:numel(hEcc)

                ax = theAxesGrid{subjIdx, eccXIndex};
                imagesc(ax, thePSFsupportDegs, thePSFsupportDegs, squeeze(thePSFs(subjIdx, eccYIndex, eccXIndex,:,:)));
                axis(ax, 'square'); 
                set(ax, 'XTick', -1:0.1:1, 'YTick', -1:0.1:1, 'XLim', psfRangeDegs*[-1 1], 'YLim', psfRangeDegs*[-1 1]);
                if (eccXIndex == 1) && (subjIdx == numel(goodSubjects))
                    ylabel(ax,'space (degs)');
                else   
                    set(ax, 'XTickLabel', {}, 'YTickLabel', {});
                end
                set(ax, 'XTickLabel', {});
                axis(ax, 'xy');
                if (subjIdx == 1)
                    title(ax,sprintf('eccX =  %2.0f^o', hEcc(eccXIndex)));
                end

                colormap(ax,cMap);
                drawnow;
           end
           end
        end % subIdx
        plotlabOBJ.exportFig(hFig, 'pdf', 'psfs', pwd());

    else

        % 2D sampling (2.5 deg)
        eccXrange = [-20 0];
        eccYrange = [0 20];
        deltaEcc = 5;

        % Compute the PSFs at the desired eccentricities
        [hEcc, vEcc, thePSFs, thePSFsupportDegs] = CronerKaplanRGCModel.psfAtEccentricity(goodSubjects, ...
            imposedRefractionErrorDiopters, eccXrange, eccYrange, deltaEcc);

        for subjectIndex = 1:numel(goodSubjects)
            hFig = figure(goodSubjects(subjectIndex)); clf;

            subplotPosVectors = NicePlot.getSubPlotPosVectors(...
                       'rowsNum', numel(vEcc), ...
                       'colsNum', numel(hEcc), ...
                       'heightMargin',  0.01, ...
                       'widthMargin',   0.01, ...
                       'leftMargin',    0.02, ...
                       'rightMargin',   0.01, ...
                       'bottomMargin',  0.01, ...
                       'topMargin',     0.01);

            for eccYIndex = 1:numel(vEcc)
                for eccXIndex = 1:numel(hEcc)
                    ax = subplot('Position', subplotPosVectors(eccYIndex, eccXIndex).v);
                    imagesc(ax, thePSFsupportDegs, thePSFsupportDegs, squeeze(thePSFs(subjectIndex, eccYIndex, eccXIndex,:,:)));
                    axis(ax, 'square'); 
                    xyRange = max(thePSFsupportDegs(:))*[-1 1]*0.25;
                    set(ax, 'XTickLabel', {}, 'YTickLabel', {}, 'XLim', xyRange, 'YLim', xyRange);
                   % title(ax,sprintf('%2.1f,%2.1f', hEcc(eccXIndex), vEcc(eccYIndex)));
                    colormap(ax,cMap);
                    drawnow;
                end
            end
            plotlabOBJ.exportFig(hFig, 'pdf', sprintf('psfs_subject%d', goodSubjects(subjectIndex)), pwd());
        end
    end
    
end

function plotlabOBJ = setupPlotLab()
    plotlabOBJ = plotlab();
    plotlabOBJ.applyRecipe(...
            'colorOrder', [0 0 0], ...
            'lineColor', [0.5 0.5 0.5], ...
            'scatterMarkerEdgeColor', [0.3 0.3 0.9], ...
            'lineMarkerSize', 10, ...
            'axesBox', 'off', ...
            'axesTickDir', 'in', ...
            'renderer', 'painters', ...
            'axesTickLength', [0.01 0.01], ...
            'legendLocation', 'SouthWest', ...
            'figureWidthInches', 18, ...
            'figureHeightInches', 16);
end
