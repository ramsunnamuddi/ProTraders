const nodePositions = new Map();
let canvasScale = 1;
function drawTree(root) {
    const canvas = document.getElementById('treeCanvas');
    const ctx = canvas.getContext('2d');
    const tooltip = document.getElementById('tooltip');

    // Clear previous data
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    nodePositions.clear();

    if (!root) return;

    const levelHeight = 120;
    const nodePadding = 15;

    function calculateNodeWidth(ctx, text) {
        ctx.font = 'bold 14px Arial';
        return Math.min(ctx.measureText(text).width + nodePadding * 2, 200);
    }

    // Step 1: Compute tree depth and max number of children at any level
    const levelWidths = {};

    function traverse(node, level = 0) {
        if (!node) return;
        if (!levelWidths[level]) levelWidths[level] = 0;
        levelWidths[level]++;
        node.children?.forEach(child => traverse(child, level + 1));
    }
    traverse(root);

    const treeDepth = Object.keys(levelWidths).length;
    const maxNodesAtLevel = Math.max(...Object.values(levelWidths));

    // Step 2: Resize canvas based on tree size
    canvas.width = Math.max(2000, maxNodesAtLevel * 200);
    canvas.height = treeDepth * levelHeight + 200;

    // Scaling calculation
    const rect = canvas.getBoundingClientRect();
    canvasScale = canvas.width / rect.width;

    const startX = canvas.width / 2;
    const startY = 80;

    function drawNode(node, x, y, level) {
        if (!node) return;

        const nodeText = node.name;
        const nodeWidth = calculateNodeWidth(ctx, nodeText);
        const nodeHeight = 35;

        // Store node position
        nodePositions.set(node.id, {
            x: x - nodeWidth / 2,
            y: y - nodeHeight / 2,
            width: nodeWidth,
            height: nodeHeight,
            data: node
        });

        // Draw node box
        ctx.beginPath();
        ctx.roundRect(x - nodeWidth / 2, y - nodeHeight / 2, nodeWidth, nodeHeight, 8);
        ctx.fillStyle = '#e3f2fd';
        ctx.fill();
        ctx.strokeStyle = '#1976d2';
        ctx.lineWidth = 2;
        ctx.stroke();

        // Draw text
        ctx.font = 'bold 14px Arial';
        ctx.textAlign = 'center';
        ctx.textBaseline = 'middle';
        ctx.fillStyle = '#0d47a1';
        ctx.fillText(nodeText, x, y);

        // Draw children
        const childCount = node.children?.length || 0;
        if (childCount > 0) {
            const totalWidth = Math.min(canvas.width - 100, childCount * 180);
            const startChildX = x - totalWidth / 2;

            node.children.forEach((child, i) => {
                const childX = startChildX + (totalWidth / Math.max(1, childCount - 1)) * i;
                const childY = y + levelHeight;

                // Draw connection
                ctx.beginPath();
                ctx.moveTo(x, y + nodeHeight / 2);
                ctx.lineTo(childX, childY - nodeHeight / 2);
                ctx.strokeStyle = '#90a4ae';
                ctx.lineWidth = 1.5;
                ctx.stroke();

                drawNode(child, childX, childY, level + 1);
            });
        }
    }

    // Draw root node and rest
    drawNode(root, startX, startY, 1);

    // Set up tooltip events
    setupHoverEvents(canvas, tooltip);
	scrollTreeToCenter();
}
function setupHoverEvents(canvas, tooltip) {
    canvas.addEventListener('mousemove', (e) => {
	    const rect = canvas.getBoundingClientRect();
	    const mouseX = (e.clientX - rect.left) * canvasScale;
	    const mouseY = (e.clientY - rect.top) * canvasScale;
	    
	    let hoveredNode = null;
	    
	    // Check all nodes for hover
	    for (const [id, node] of nodePositions.entries()) {
	        if (mouseX >= node.x && mouseX <= node.x + node.width &&
	            mouseY >= node.y && mouseY <= node.y + node.height) {
	            hoveredNode = node;
	            break;
	        }
	    }
	    
	    if (hoveredNode) {
	        const nodeData = hoveredNode.data;
	        tooltip.innerHTML = `
	            <h3>${nodeData.name}</h3>
	            <p><strong>ID:</strong> ${nodeData.id}</p>
	            <p><strong>Joined on:</strong> ${nodeData.joiningDate}</p>
	        `;
	        tooltip.style.display = 'block';
	        tooltip.style.left = `${e.clientX + 15}px`;
	        tooltip.style.top = `${e.clientY + 15}px`;
	    } else {
	        tooltip.style.display = 'none';
	    }
	});
	
	canvas.addEventListener('mouseout', () => {
	    tooltip.style.display = 'none';
	});
}

function measureTree(node, level = 0, max = { width: 0, height: 0 }) {
    const horizontalSpacing = 200;
    const verticalSpacing = 120;
    const nodeWidth = 120;

    if (level > max.height) {
        max.height = level;
    }

    max.width += nodeWidth + horizontalSpacing;

    for (const child of node.children || []) {
        measureTree(child, level + 1, max);
    }

    return max;
}

function scrollTreeToCenter() {
    const container = document.getElementById("treeContainer");

    // Scroll to the horizontal and vertical center
    container.scrollTop = (container.scrollHeight - container.clientHeight) / 2;
    container.scrollLeft = (container.scrollWidth - container.clientWidth) / 2;
}
