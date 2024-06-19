<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>이미지 붙여넣기</title>
</head>
<body>
<canvas id="myCanvas" width="400" height="400" style="border:1px solid #000;"></canvas><br>
<button onclick="pasteImage()">PASTE IMAGE</button>

<script>
function pasteImage() {
    // 클립보드에서 이미지 가져오기
    navigator.clipboard.read().then(data => {
        data.forEach(clip => {
            if (clip.types.includes('image/png') || clip.types.includes('image/jpeg')) {
                clip.getType('image/png').then(blob => {
                    // Blob을 이미지로 변환
                    var img = new Image();
                    img.onload = function() {
                        // Canvas에 이미지 그리기
                        var canvas = document.getElementById('myCanvas');
                        var ctx = canvas.getContext('2d');
                        ctx.drawImage(img, 0, 0, canvas.width, canvas.height);
                    };
                    img.src = URL.createObjectURL(blob);
                });
            }
        });
    });
}
</script>
</body>
</html>
