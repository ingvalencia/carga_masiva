import { createRoot } from 'react-dom/client';
import ExcelUploader from './components/ExcelUploader';

const container = document.getElementById('root');
const root = createRoot(container);
root.render(<ExcelUploader />);
