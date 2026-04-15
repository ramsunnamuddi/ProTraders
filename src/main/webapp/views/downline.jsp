<div class="container mt-4">
        <!-- Tabs -->
        <ul class="nav nav-tabs" id="dldataTabs">
            <li class="nav-item">
                <a class="nav-link active disabled" data-tab="ds" onclick="switchDlTab(event)">Direct Sponsor</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" data-tab="ld" onclick="switchDlTab(event)">Level Downline</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" data-tab="tt" onclick="switchDlTab(event)">Total Team</a>
            </li>
			<li class="nav-item">
               <a class="nav-link" data-tab="gt" onclick="switchDlTab(event)">Genealogy Tree</a>
           </li>
        </ul>
		<!-- Tab Content -->
	    <div class="tab-content mt-3" id="tabContent">
	          <div id="tabData" class="table-responsive">
	              <p class="text-center">Loading data...</p>
	          </div>
	      </div>
		  
	  </div>