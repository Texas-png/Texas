const API_BASE = 'http://localhost:8080';
let todos = [];
let currentFilter = 'all';

// --- API ---
async function fetchTodos() {
  const res = await fetch(`${API_BASE}/todos`);
  const data = await res.json();
  todos = data.todos || [];
  render();
}

async function createTodo(title, description, priority) {
  const res = await fetch(`${API_BASE}/todos`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ title, description, priority })
  });
  return res.json();
}

async function toggleTodo(id) {
  const res = await fetch(`${API_BASE}/todos/${id}`, { method: 'PUT' });
  return res.json();
}

async function deleteTodo(id) {
  const res = await fetch(`${API_BASE}/todos/${id}`, { method: 'DELETE' });
  return res.json();
}

// --- Render ---
function render() {
  const list = document.getElementById('todo-list');
  const filtered = filterTodos();

  if (filtered.length === 0) {
    list.innerHTML = '<p class="empty-msg">暂无待办事项</p>';
    return;
  }

  list.innerHTML = filtered.map(t => `
    <div class="todo-item" data-id="${t.id}">
      <button class="todo-check${t.status === 'completed' ? ' done' : ''}" 
              onclick="handleToggle(${t.id})">
        ${t.status === 'completed' ? '✓' : ''}
      </button>
      <div class="todo-body">
        <div class="todo-title${t.status === 'completed' ? ' completed' : ''}">${escapeHtml(t.title)}</div>
        ${t.description ? `<div class="todo-desc">${escapeHtml(t.description)}</div>` : ''}
        <div class="todo-meta">
          <span class="priority-badge priority-${t.priority}">${priorityLabel(t.priority)}</span>
          <span class="todo-date">${t.created_at || ''}</span>
        </div>
      </div>
      <button class="delete-btn" onclick="handleDelete(${t.id})" title="删除">×</button>
    </div>
  `).join('');
}

function filterTodos() {
  if (currentFilter === 'all') return todos;
  return todos.filter(t => t.status === currentFilter);
}

// --- Handlers ---
async function handleToggle(id) {
  await toggleTodo(id);
  await fetchTodos();
}

async function handleDelete(id) {
  await deleteTodo(id);
  await fetchTodos();
}

function handleFilter(filter) {
  currentFilter = filter;
  document.querySelectorAll('.filter-btn').forEach(btn => {
    btn.classList.toggle('active', btn.dataset.filter === filter);
  });
  render();
}

// --- Form ---
document.getElementById('todo-form').addEventListener('submit', async (e) => {
  e.preventDefault();
  const title = document.getElementById('todo-title').value.trim();
  if (!title) return;

  const description = document.getElementById('todo-desc').value.trim();
  const priority = document.getElementById('todo-priority').value;

  await createTodo(title, description, priority);
  document.getElementById('todo-form').reset();
  await fetchTodos();
});

// --- Utils ---
function priorityLabel(p) {
  return { low: '低', medium: '中', high: '高' }[p] || p;
}

function escapeHtml(text) {
  const div = document.createElement('div');
  div.textContent = text;
  return div.innerHTML;
}

// --- Init ---
fetchTodos();
