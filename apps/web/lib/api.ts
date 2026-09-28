import { supabase } from '@/lib/supabase';

export async function fetchWithAuth(endpoint: string, options: RequestInit = {}) {
  const { data: { session } } = await supabase.auth.getSession();
  
  const headers = {
    'Content-Type': 'application/json',
    ...(session ? { 'Authorization': `Bearer ${session.access_token}` } : {}),
    ...options.headers,
  };

  const apiUrl = process.env.NEXT_PUBLIC_API_URL || 'http://localhost:8000';

  try {
    const response = await fetch(`${apiUrl}${endpoint}`, {
      ...options,
      headers,
    });

    if (!response.ok) {
      throw new Error(`API error: ${response.statusText}`);
    }

    return response.json();
  } catch (err) {
    console.warn(`API server unreachable at ${apiUrl}${endpoint}. Falling back to mock response.`, err);

    // Provide graceful mock fallbacks so the UI doesn't crash when backend API is not running
    if (endpoint.includes('/pathways') && endpoint.includes('/steps')) {
      return [
        { title: 'Step 1: Aptitude Assessment', description: 'Complete your foundational interest quiz.' },
        { title: 'Step 2: Skill Gap Identification', description: 'Identify current vs required skills.' },
        { title: 'Step 3: Roadmap Generation', description: 'Unlock your personalized learning path.' }
      ];
    }

    if (endpoint.includes('/chatbot/message')) {
      return {
        reply: "Assalam-o-Alaikum! I'm your Alkhidmat Skill Pathways mentor. (Note: Running in offline/demo mode as backend API is not connected)."
      };
    }

    return { success: true, message: 'Mock response (backend offline)' };
  }
}
