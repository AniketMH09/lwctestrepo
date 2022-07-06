function adaissues() {
	console.log('inside js);
let arr = document.getElementsByTagName("svg");
for(let i = 0;i < arr.length;i++){
console.log('arr', arr[i]);
	arr[i].setAttribute("role", "img");
}
}