(function() {
    'use strict';
    angular
        .module('MyApp')
        .controller('IncrementalSearch', IncrementalSearch);

    function IncrementalSearch($q, $log, $filter, $http) {
        var vm = this;

        vm.simulateQuery = true;
        vm.querySearch = querySearch;
        vm.selectedItemChange = selectedItemChange;
        vm.assetsSelectedRemove = assetsSelectedRemove;
        vm.assetsSelected = [];
        vm.assetsLoaded = [];
        vm.deferred = null;

        function querySearch(query) {
            vm.deferred = $q.defer();
            var jsonquery = "";
            if (query !== null && query !== "")
                jsonquery = "&query=" + query.replace(/\s/g, "+");
            $http({
                method: 'GET',
                url: 'https://discovery.organicity.eu/v0/assets/metadata/search?' + jsonquery
            }).then(
                function successCallback(response) {
                    vm.deferred.resolve(vm.assetsLoaded = response.data);
                },
                function errorCallback(response) {});
            return vm.deferred.promise;
        }

        function selectedItemChange(item) {
            if (item) {
                //check if item is already selected
                if ($filter('filter')(vm.assetsSelected, function(d) {
                        return d.id === item.id;
                    })[0]) {} else {
                    //add id to object
                    vm.assetsSelected.push(item);
                }
                // clear search field
                vm.searchText = '';
                vm.selectedItem = undefined;

                //somehow blur the autocomplete focus
                $mdAutocompleteCtrl.blur();
            }
        }

        function assetsSelectedRemove(item) {
            var index = vm.assetsSelected.indexOf(item);
            vm.assetsSelected.splice(index, 1);
        }
    }
})();