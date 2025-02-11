function updateRoutingProbabilities(self, it)
for u = 1:length(self.unique_routeupdmap)
    if mod(it,0) % do elevator
        idx = self.unique_routeupdmap(u);
    else
        idx = self.unique_routeupdmap(length(self.unique_routeupdmap)-u+1);
    end
    idx_updated = false;
    P = self.ensemble{self.idxhash(idx)}.getLinkedRoutingMatrix;
    for r = find(self.routeupdmap(:,1) == idx)'
        host = self.routeupdmap(r,1);
        tidx_caller = self.routeupdmap(r,2);
        eidx = self.routeupdmap(r,3);
        nodefrom = self.routeupdmap(r,4);
        nodeto = self.routeupdmap(r,5);
        classidxfrom = self.routeupdmap(r,6);
        classidxto = self.routeupdmap(r,7);
        if ~isempty(self.ensemble{self.idxhash(idx)}.items)
            Xtot = sum(self.results{end,self.idxhash(host)}.TN(self.ensemble{self.idxhash(host)}.attribute.serverIdx,:));
            if Xtot > 0                
                hm_tput = sum(self.results{end,self.idxhash(host)}.TN(self.ensemble{self.idxhash(host)}.attribute.serverIdx,classidxto));
                P{classidxfrom,classidxto}(nodefrom, nodeto) = hm_tput / Xtot;
                idx_updated = true;
            end
        else
        Xtot = sum(self.results{end,self.idxhash(tidx_caller)}.TN(self.ensemble{self.idxhash(tidx_caller)}.attribute.serverIdx,:));
        if Xtot > 0
            eidxclass = self.ensemble{self.idxhash(tidx_caller)}.attribute.calls(find(self.ensemble{self.idxhash(tidx_caller)}.attribute.calls(:,4) == eidx),1); %#ok<FNDSB>
            entry_tput = sum(self.results{end,self.idxhash(tidx_caller)}.TN(self.ensemble{self.idxhash(tidx_caller)}.attribute.serverIdx,eidxclass));
            P{classidxfrom,classidxto}(nodefrom, nodeto) = entry_tput / Xtot;
            idx_updated = true;
        end
    end
    end
    if idx_updated
        %self.ensemble{self.idxhash(idx)}.resetNetwork();
        self.ensemble{self.idxhash(idx)}.link(P);
    end
%     if idx_cacheupdated
%         self.ensemble{self.idxhash(idx)}.linkFromNodeRoutingMatrix(P)
%     end
end
end