$(document).ready(function() {
	$('#searchResultsTableBody').data('searchResults', []);
	$('#movieListTableBody').data('movieList', []);
	drawSearchResultsTable();
	drawMovieListTable();
	$('button.searchButton').click(function() {
		var searchTerm = $('#searchBox').val();
		updateSearchResults(searchTerm);
		drawSearchResultsTable();
		$('#searchBox').val('');
	});
	$('#searchBox').keyup(function(event) {
		if(event.keyCode==13) {
			$('button.searchButton').click();
		}
	});
	$(document).on('click','button.addButton', function() {
		var searchResultIndex = $(this).parent().parent().index();
		addSearchResultToMovieList(searchResultIndex);
		drawMovieListTable();
		deleteSearchResult(searchResultIndex);
		drawSearchResultsTable();
	});
	$(document).on('click','button.updateButton', function() {
		var movieItemIndex = $(this).parent().parent().index();
		updateMovieItem(movieItemIndex);
		drawMovieListTable();
	});
	$(document).on('click','button.removeButton', function() {
		var movieItemIndex = $(this).parent().parent().index();
		removeMovieItem(movieItemIndex);
		drawMovieListTable();
	});
});

var updateSearchResults = function(searchTerm) {
	var searchResults = [];
	if(Math.random() > 0.5) {
		numSequels = Math.floor(Math.random()*4);
		initialReleaseYear = 1980 + Math.floor(Math.random()*30);
		searchResults[0] = {
			id: Math.floor(Math.random()*1000000),
			title: searchTerm,
			releaseYear: initialReleaseYear
		};
		if(numSequels > 0) {
			for(var i=1; i <= numSequels; i++){
				searchResults[i] = {
					id: Math.floor(Math.random()*1000000),
				title: searchTerm + " " + String(i+1),
					releaseYear: initialReleaseYear + 2*i
				};
			}
		}
	}
	$('#searchResultsTableBody').data('searchResults', searchResults);
}

var drawSearchResultsTable = function() {
	var searchResults = $('#searchResultsTableBody').data('searchResults');
	$('#searchResultsTableBody').empty();
	if(searchResults.length===0) {
		var searchResultsTableRowHTML = (
			"<tr><td colspan='3'><em>No search results</em></td></tr>"
		)
		$('#searchResultsTableBody').append(searchResultsTableRowHTML);
	}
	else {
		for(var i=0; i < searchResults.length; i++) {
			var searchResultsTableRowHTML = (
				"<tr><td>" +
				searchResults[i].title +
				"</td><td>" +
				searchResults[i].releaseYear +
				"</td><td>" +
				"<button class='addButton'>Add</button>" +
				"</td></tr>"
				);
			$('#searchResultsTableBody').append(searchResultsTableRowHTML);
		}
	}
}

var addSearchResultToMovieList = function(searchResultIndex) {
	var movieList = $('#movieListTableBody').data('movieList');
	var searchResult = $('#searchResultsTableBody').data('searchResults')[searchResultIndex];
	var streamingInfo = getStreamingInfo(searchResult.id);
	var newMovieListItem = {
		id: searchResult.id,
		title: searchResult.title,
		releaseYear: searchResult.releaseYear,
		netflixStreaming: streamingInfo.netflixStreaming,
		netflixRental: streamingInfo.netflixRental,
		amazonStreaming: streamingInfo.amazonStreaming,
		amazonRental: streamingInfo.amazonRental,
		huluStreaming: streamingInfo.huluStreaming,
		huluRental: streamingInfo.huluRental,
		vuduStreaming: streamingInfo.vuduStreaming,
		vuduRental: streamingInfo.vuduRental,
		updated: streamingInfo.updated
	}
	movieList.push(newMovieListItem);
	$('#movieListTableBody').data('movieList', movieList);
}

var getStreamingInfo = function(movieID) {
	var streamingInfo = {
		netflixStreaming: randomStreamingInfo(),
		netflixRental: randomStreamingInfo(),
		amazonStreaming: randomStreamingInfo(),
		amazonRental: randomStreamingInfo(),
		huluStreaming: randomStreamingInfo(),
		huluRental: randomStreamingInfo(),
		vuduStreaming: randomStreamingInfo(),
		vuduRental: randomStreamingInfo(),
		updated: new Date()
	}
	return(streamingInfo);
}

var randomStreamingInfo = function() {
	if(Math.random() > 0.5) {
		return("$" + Math.floor(Math.random()*4) + ".99");
	}
	else {
		return("");
	}
}

var drawMovieListTable = function() {
	var movieList = $('#movieListTableBody').data('movieList');
	$('#movieListTableBody').empty();
	if(movieList.length===0){
		var movieListTableRowHTML = (
			"<tr><td colspan='13'><em>No movies in list</em></td></tr>"
		);
		$('#movieListTableBody').append(movieListTableRowHTML);		
	}
	else {
		for(var i=0; i < movieList.length; i++) {
			var movieListTableRowHTML = (
				"<tr><td>" +
				movieList[i].title +
				"</td><td>" +
				movieList[i].releaseYear +
				"</td><td>" +
				movieList[i].netflixStreaming +
				"</td><td>" +
				movieList[i].netflixRental +
				"</td><td>" +
				movieList[i].amazonStreaming +
				"</td><td>" +
				movieList[i].amazonRental +
				"</td><td>" +
				movieList[i].huluStreaming +
				"</td><td>" +
				movieList[i].huluRental +
				"</td><td>" +
				movieList[i].vuduStreaming +
				"</td><td>" +
				movieList[i].vuduRental +
				"</td><td>" +
				formatDate(movieList[i].updated) +
				"</td><td>" +
				"<button class='updateButton'>Update</button>" +
				"</td><td>" +
				"<button class='removeButton'>Remove</button>" +
				"</td></tr>"
			);
			$('#movieListTableBody').append(movieListTableRowHTML);
		}
	}
}

var deleteSearchResult = function(searchResultIndex) {
	var searchResults = $('#searchResultsTableBody').data('searchResults');
	searchResults.splice(searchResultIndex,1);
	$('#searchResultsTableBody').data('searchResults', searchResults);
}

var updateMovieItem = function(movieItemIndex) {
	var movieList = $('#movieListTableBody').data('movieList');
	var streamingInfo = getStreamingInfo(movieList[movieItemIndex].id);
	movieList[movieItemIndex].netflixStreaming = streamingInfo.netflixStreaming,
	movieList[movieItemIndex].netflixRental = streamingInfo.netflixRental,
	movieList[movieItemIndex].amazonStreaming = streamingInfo.amazonStreaming,
	movieList[movieItemIndex].amazonRental = streamingInfo.amazonRental,
	movieList[movieItemIndex].huluStreaming = streamingInfo.huluStreaming,
	movieList[movieItemIndex].huluRental = streamingInfo.huluRental,
	movieList[movieItemIndex].vuduStreaming = streamingInfo.vuduStreaming,
	movieList[movieItemIndex].vuduRental = streamingInfo.vuduRental,
	movieList[movieItemIndex].updated = streamingInfo.updated
	$('#movieListTableBody').data('movieList', movieList);
}

var removeMovieItem = function(movieItemIndex) {
	var movieList = $('#movieListTableBody').data('movieList');
	movieList.splice(movieItemIndex,1);
	$('#movieListTableBody').data('movieList', movieList);
}

function formatDate(date) {
	var hours = date.getHours();
	var minutes = date.getMinutes();
	var seconds = date.getSeconds();
	hours = hours < 10 ? '0'+hours : hours;
	minutes = minutes < 10 ? '0'+minutes : minutes;
	seconds = seconds < 10 ? '0'+seconds : seconds;
	return (
		(date.getMonth() + 1) +
		"/" +
		date.getDate() +
		"/" +
		date.getFullYear() +
		" " +
		hours +
		":" +
		minutes +
		":" +
		seconds
	)
}